$(document).ready(function(){
  $('#filter-order-manager').on('change', function(){
    action_type = $('input[name=status]:checked').val()
    $.ajax({
      url: $(this).attr('action'),
      type: 'GET',
      data:{
        domain_id: $(this).val(),
        type: action_type
      }
    });
  });

  $('.manage-order-status').on('click', function(){
    $.ajax({
      url: $(this).attr('action'),
      type: 'GET',
      data:{
        type: $(this).val(),
        domain_id: $('#filter-order-manager').val()
      }
    });
  })
});
