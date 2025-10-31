// @ts-nocheck
// Supabase Edge Function: update_badges
// Automatically updates user points, badges, and secret reward status when an admin confirms a drop-off.

import { createClient } from "https://esm.sh/@supabase/supabase-js@2";
import { serve } from "https://deno.land/std@0.208.0/http/server.ts";

type UpdateBadgesPayload = {
  user_id: string;
  points_awarded: number;
  drop_off_id?: string;
};

type UserRecord = {
  id: string;
  points: number;
  badges: string[] | null;
  secret_reward: boolean | null;
};

const supabaseUrl =
  Deno.env.get("PROJECT_URL") ?? Deno.env.get("SUPABASE_URL");
const serviceRoleKey =
  Deno.env.get("SERVICE_ROLE_KEY") ??
  Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");

if (!supabaseUrl || !serviceRoleKey) {
  console.error("Missing SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY environment variables.");
}

const supabase = createClient(supabaseUrl!, serviceRoleKey!, {
  auth: { persistSession: false },
});

const BADGE_THRESHOLDS: { threshold: number; badge: string }[] = [
  { threshold: 100, badge: "Recycler Lv1" },
  { threshold: 250, badge: "Recycler Lv2" },
  { threshold: 500, badge: "Recycler Lv3" },
];

serve(async (req) => {
  try {
    if (req.method !== "POST") {
      return new Response(JSON.stringify({ error: "Method not allowed" }), {
        status: 405,
        headers: { "Content-Type": "application/json" },
      });
    }

    const payload = (await req.json()) as UpdateBadgesPayload;

    if (!payload.user_id || typeof payload.points_awarded !== "number") {
      return new Response(JSON.stringify({ error: "Invalid payload" }), {
        status: 400,
        headers: { "Content-Type": "application/json" },
      });
    }

    const { data: user, error: userError } = await supabase
      .from("users")
      .select("id, points, badges, secret_reward")
      .eq("id", payload.user_id)
      .maybeSingle<UserRecord>();

    if (userError) {
      console.error("Failed to fetch user", userError);
      throw userError;
    }

    if (!user) {
      return new Response(JSON.stringify({ error: "User not found" }), {
        status: 404,
        headers: { "Content-Type": "application/json" },
      });
    }

    const newTotalPoints = (user.points ?? 0) + payload.points_awarded;
    const badges = new Set(user.badges ?? []);

    for (const { threshold, badge } of BADGE_THRESHOLDS) {
      if (newTotalPoints >= threshold) {
        badges.add(badge);
      }
    }

    const updatePayload: Record<string, unknown> = {
      points: newTotalPoints,
      badges: Array.from(badges),
    };

    const { data: topUser, error: leaderboardError } = await supabase
      .from("users")
      .select("id")
      .order("points", { ascending: false })
      .limit(1)
      .maybeSingle<{ id: string }>();

    if (leaderboardError) {
      console.error("Failed to determine top user", leaderboardError);
    }

    if (topUser && topUser.id === user.id) {
      updatePayload.secret_reward = true;
      updatePayload.reward_claimed_at = new Date().toISOString();
    }

    const { error: updateError } = await supabase
      .from("users")
      .update(updatePayload)
      .eq("id", user.id);

    if (updateError) {
      console.error("Failed to update user", updateError);
      throw updateError;
    }

    return new Response(JSON.stringify({ success: true, points: newTotalPoints, badges: updatePayload.badges }), {
      status: 200,
      headers: { "Content-Type": "application/json" },
    });
  } catch (error) {
    console.error("Unexpected error in update_badges function", error);
    return new Response(JSON.stringify({ error: "Internal server error" }), {
      status: 500,
      headers: { "Content-Type": "application/json" },
    });
  }
});
