// サイドメニューの表示・非表示を管理するスクリプト
document.addEventListener('turbo:load', function() {
  initSideMenu();
});

document.addEventListener('DOMContentLoaded', function() {
  initSideMenu();
});

function initSideMenu() {
  const sideMenu = document.getElementById('sideMenu');
  const openSideMenuBtn = document.getElementById('openSideMenuBtn');
  const closeSideMenuBtn = document.getElementById('closeSideMenuBtn');
  const sideMenuOverlay = document.getElementById('sideMenuOverlay');

  // メニューを開く
  if (openSideMenuBtn) {
    openSideMenuBtn.addEventListener('click', function() {
      sideMenu.classList.add('show');
      sideMenuOverlay.classList.add('show');
      document.body.style.overflow = 'hidden'; // スクロール防止
    });
  }

  // メニューを閉じる
  if (closeSideMenuBtn) {
    closeSideMenuBtn.addEventListener('click', function() {
      closeSideMenu();
    });
  }

  // オーバーレイクリックでもメニューを閉じる
  if (sideMenuOverlay) {
    sideMenuOverlay.addEventListener('click', function() {
      closeSideMenu();
    });
  }

  // 画面サイズが変わった時の対応
  window.addEventListener('resize', function() {
    if (window.innerWidth > 768) {
      // デスクトップサイズになったらメニューを表示
      if (sideMenu) sideMenu.classList.remove('show');
      if (sideMenuOverlay) sideMenuOverlay.classList.remove('show');
      document.body.style.overflow = '';
    }
  });

  // メニューを閉じる共通関数
  function closeSideMenu() {
    if (sideMenu) sideMenu.classList.remove('show');
    if (sideMenuOverlay) sideMenuOverlay.classList.remove('show');
    document.body.style.overflow = ''; // スクロール復活
  }
}
