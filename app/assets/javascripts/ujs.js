function delCSV(dom_id, v) {
  var node = $("#" + dom_id);
  var vs = String(node.val()).split(/\s*,\s*/).reduce(function(acc, cur, idx) {
    if(!!cur && String(cur) != String(v)) acc.push(cur);
    return acc;
  }, []);

  node.val(vs.join(","));
};

function putCSV(dom_id, v) {
  var node = $("#" + dom_id);
  var vs = String(node.val()).split(/\s*,\s*/).reduce(function(acc, cur, idx) {
    if(!!cur) acc.push(cur);
    return acc;
  }, []);
  vs.push(v);
  node.val(vs.join(","));
};

function do_upload(file_input) {
  $("#" + file_input).click();
};

function initFns() {
  $("a.fn:not('.sd-fnized')").each(function(i, a) {
    $(a).addClass("sd-x sd-fnized");

    var _fn = $(a).attr("data-fn");
    var _args = $(a).attr("data-args") || null;
    $(a).off("click", "**");
    $(a).on("click", function(event) {
      event.preventDefault();
      var final_args;
      if(_args) {
        final_args = _args.split(/\s*,\s*/).concat([event]);
      } else {
        final_args = [event]
      }
      try {
        eval(_fn).apply(this, final_args);
      } catch(e) {
        // alert(e);
      }
    });
  });
};
