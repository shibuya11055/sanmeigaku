// サイドメニューの表示・非表示を管理するスクリプト
document.addEventListener('turbo:load', function() {
  initSideMenu();
});

document.addEventListener('DOMContentLoaded', function() {
  initSideMenu();
});

function initSideMenu() {
  const sideMenu = document.getElementById('sideMenu');
  const toggleMenuBtn = document.getElementById('toggleMenuBtn');
  const contentArea = document.querySelector('.content-area');

  if (!sideMenu || !toggleMenuBtn) {
    console.log('サイドメニュー要素が見つかりません');
    return;
  }

  // 画面サイズに応じたメニュー状態の設定
  function setMenuStateByScreenSize() {
    if (window.innerWidth <= 768) {
      // タブレットサイズ以下では縮小表示
      sideMenu.classList.add('collapsed');
      if (contentArea) contentArea.classList.add('collapsed-margin');

      // ボタンのアイコンを右向きに
      const toggleIcon = toggleMenuBtn.querySelector('i');
      if (toggleIcon) {
        toggleIcon.classList.remove('fa-chevron-left');
        toggleIcon.classList.add('fa-chevron-right');
      }
    } else {
      // 通常サイズのデスクトップでは展開表示
      sideMenu.classList.remove('collapsed');
      if (contentArea) contentArea.classList.remove('collapsed-margin');

      // ボタンのアイコンを左向きに
      const toggleIcon = toggleMenuBtn.querySelector('i');
      if (toggleIcon) {
        toggleIcon.classList.remove('fa-chevron-right');
        toggleIcon.classList.add('fa-chevron-left');
      }
    }
  }

  // 初期設定
  setMenuStateByScreenSize();

  // メニューを展開/縮小する
  toggleMenuBtn.addEventListener('click', function(e) {
    e.preventDefault();
    toggleMenuCollapse();
  });

  // 画面サイズが変わった時の対応
  window.addEventListener('resize', function() {
    setMenuStateByScreenSize();
  });

  // メニューの展開/縮小を切り替え
  function toggleMenuCollapse() {
    const isCollapsed = sideMenu.classList.toggle('collapsed');

    if (contentArea) {
      contentArea.classList.toggle('collapsed-margin', isCollapsed);
    }

    // 展開/縮小ボタンのアイコンを変更
    const toggleIcon = toggleMenuBtn.querySelector('i');
    if (toggleIcon) {
      if (isCollapsed) {
        toggleIcon.classList.remove('fa-chevron-left');
        toggleIcon.classList.add('fa-chevron-right');
      } else {
        toggleIcon.classList.remove('fa-chevron-right');
        toggleIcon.classList.add('fa-chevron-left');
      }
    }
  }
}
