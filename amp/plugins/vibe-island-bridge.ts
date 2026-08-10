// @i-know-the-amp-plugin-api-is-wip-and-very-experimental-right-now
// vibeisland.app — Amp lifecycle event bridge
// PROVENANCE: 92A9765B
import { execSync } from "child_process";
const B = `${process.env.HOME}/.vibe-island/bin/vibe-island-bridge`;
function send(e, d = {}) {
  try {
    const p = JSON.stringify({ hook_event_name: e, ...d });
    execSync(`printf '%s' '${p.replace(/'/g, "'\''")}' | "${B}" --source amp`, { timeout: 5000 });
  } catch {}
}
export default (amp) => {
  const sid = () => amp.threadId || "";
  amp.on("session.start", () => {
    send("SessionStart", { session_id: sid(), cwd: process.cwd() });
  });
  amp.on("agent.start", () => {
    send("UserPromptSubmit", { session_id: sid(), cwd: process.cwd() });
  });
  amp.on("agent.end", () => {
    send("Stop", { session_id: sid() });
  });
  amp.on("tool.call", (ev) => {
    send("PreToolUse", { session_id: sid(), tool_name: ev.tool || "" });
    return { action: "allow" };
  });
  amp.on("tool.result", (ev) => {
    send("PostToolUse", { session_id: sid(), tool_name: ev.tool || "" });
    return { action: "allow" };
  });
};