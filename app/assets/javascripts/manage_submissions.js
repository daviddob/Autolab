var hideStudent;

jQuery(function($) {


  $.fn.dataTableExt.afnFiltering.push(
    function(settings, data, dataIndex) {
      var filterOnlyLatest = $("#only-latest").is(':checked');
      if (!filterOnlyLatest) {
        // if not filtered, return all the rows
        return true;
      } else {
        var isSubmissionLatest = data[7]; // use data for the age column
        return (isSubmissionLatest == "true");
      }
    }
  );

  $.fn.dataTableExt.afnFiltering.push(
    function(settings, data, dataIndex) {
      var hideStudent = $("#hide-students").is(':checked');
      var hideCA = $("#hide-ca").is(':checked');
      var hideInstructor = $("#hide-instructors").is(':checked');
      var role = data[8];

      if(role == "instructor" && hideInstructor){
        return false;
      }
      if(role == "student" && hideStudent){
        return false;
      }      
      if(role == "assistant" && hideCA){
        return false;
      }

      return true;
    }
  );

  var $floater = $("#floater"),
    $backdrop = $("#gradeBackdrop");
  $('.trigger').bind('ajax:success', function showStudent(event, data, status, xhr) {
    $floater.html(data);
    $floater.show();
    $backdrop.show();
  });

  /** override the global **/
  hideStudent = function hideStudent() {
    $floater.hide();
    $backdrop.hide();
  };

  var table = $('#submissions').DataTable({
    'sPaginationType': 'full_numbers',
    'iDisplayLength': 100,
    'pageLength': 50,
    'oLanguage': {
      'sLengthMenu':
        '<div class="row">' +
        '<div class="sort-item"><input type="checkbox" id="only-latest"><label for="only-latest">Show only latest</label></div>'+
        '<div class="sort-item"><input type="checkbox" id="hide-instructors"><label for="hide-instructors">Hide Instructors</label></div>'+
        '<div class="sort-item"><input type="checkbox" id="hide-ca"><label for="hide-ca">Hide Course Assistants</label></div>'+
        '<div class="sort-item"><input type="checkbox" id="hide-students"><label for="hide-students">Hide Students</label></div>'+
        '</div>'
    },
    "aaSorting": [
      [3, "desc"]
    ],
    "aoColumnDefs": [
      { "bSortable": false, "aTargets": [ 0 ] },
      {"bVisible": false, "aTargets": [7, 8]}
    ]
  });

  $(".sort-item input").on("change", function() {
    table.draw();
  });

  var ids = [];
  $("input.checkbox:checked").each(function() {
    ids.push($(this).val());
  });

  var selectedSubmissions = [];

  var initialBatchUrl = $("#batch-regrade").prop("href");

  function updateBatchRegradeButton() {

    if (selectedSubmissions.length == 0) {
      $("#batch-regrade").fadeOut(120);
    } else {
      $("#batch-regrade").fadeIn(120);
    }
    var urlParam = $.param({
      "submission_ids": selectedSubmissions
    });
    var newHref = initialBatchUrl + "?" + urlParam;
    $("#batch-regrade").html("Regrade " + selectedSubmissions.length + " Submissions")
    $("#batch-regrade").prop("href", newHref);
  };

  function toggleRow(submissionId) {
    if (selectedSubmissions.indexOf(submissionId) < 0) {
      // not in the list
      selectedSubmissions.push(submissionId);
      $("#cbox-" + submissionId).prop('checked', true);
      $("#row-" + submissionId).addClass("selected");
    } else {
      // in the list
      $("#cbox-" + submissionId).prop('checked', false);
      $("#row-" + submissionId).removeClass("selected");
      selectedSubmissions = _.without(selectedSubmissions, submissionId);
    }

    updateBatchRegradeButton();
  }

  $('#submissions').on("click", ".submission-row", function(e) {
    // Don't toggle row if we originally clicked on an anchor tag
    if(e.target.localName != 'a') {
      // e.target: tightest element that triggered the event
      // e.currentTarget: element the event has bubbled up to currently
      var submissionId = parseInt(e.currentTarget.id.replace("row-", ""), 10);
      toggleRow(submissionId);
      return false;
    }
  });


  $('#submissions').on("click", ".all-header" ,function(e) {
    $(".submission-row").each(function(index){
      var submissionId = parseInt($(this)[0].id.replace("row-", ""), 10);
      toggleRow(submissionId);
    });
    $('#sall').prop("checked", !$('#sall').prop("checked"));
    // $('.cbox').trigger("click");
  });

  $('.regrade-override').click(function(e) {
    // Because regrade requests are sent with `data-method="post"`, we need to
    // trick the link into behaving... like a link. When holding down Ctrl or
    // Cmd, the regrade should open in a new tab.
    if (e.metaKey || e.ctrlKey) {
      $(this).attr('target', '_blank');
    }
  });

  $('input[type=checkbox]').prop("checked", false);

});
