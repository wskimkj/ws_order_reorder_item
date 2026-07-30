/* =========================================================
   공용 설정 파일 — index.html, upload.html, login.html 이 공유합니다.
   본인 Supabase 프로젝트 값으로 아래 두 줄만 수정하세요.
   ========================================================= */
const SUPABASE_URL = "https://mxanrwyzdgtgzikprvnl.supabase.co";
const SUPABASE_ANON_KEY = "sb_publishable_X-YyQ0JXxGCv0RowNESzSw_P8YKUA4A";

const supabaseClient = window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

// 로그인이 안 되어 있으면 login.html로 이동시킵니다.
// 보호가 필요한 페이지(index.html, upload.html) 상단에서 호출하세요.
async function requireAuth(){
  const { data: { session } } = await supabaseClient.auth.getSession();
  if (!session){
    window.location.href = "login.html";
    return null;
  }
  return session;
}

async function logout(){
  await supabaseClient.auth.signOut();
  window.location.href = "login.html";
}

// 헤더에 로그인한 사용자 이메일 + 로그아웃 버튼을 그려주는 헬퍼
function renderUserBar(session, mountEl){
  if (!session || !mountEl) return;
  mountEl.innerHTML = `
    <span style="color:var(--ink-soft);font-size:13px;">${session.user.email}</span>
    <button id="logoutBtn" style="
      padding:6px 12px;font-size:13px;font-weight:600;
      background:transparent;color:var(--accent);
      border:1px solid var(--line);border-radius:6px;cursor:pointer;">로그아웃</button>
  `;
  document.getElementById("logoutBtn").addEventListener("click", logout);
}
