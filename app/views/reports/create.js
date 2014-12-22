$('.report-modal select, .report-modal textarea').val('');
$('.report-modal').modal('hide');
$('<div class="alert alert-success">Your report has been received.</div>').prependTo('.page-content > .row');
