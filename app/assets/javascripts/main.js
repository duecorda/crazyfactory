function closeCover() {
  $("section.main").css({position: "relative"});
  restoreST();
  $("#fullcover").html("").hide();
};

function initCover() {
  storeST();
  $("section.main").css({position: "fixed"});
  $("#fullcover").show();
}

function storeST() {
  window.st = $(window).scrollTop();
};
function restoreST() {
  $(window).scrollTop(window.st);
};
