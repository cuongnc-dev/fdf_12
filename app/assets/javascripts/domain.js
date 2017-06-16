$(document).ready(function() {
  var id, top, left;
  var width = $(window).width();
  var height = $(window).height();
  $(document).on('mousemove', function(e) {
    top = e.clientY;
    left = e.clientX;
  });
  $('.image_product').hover(function() {
    id = 'item-' + $(this).data('product-id');
    timer = setTimeout(function(){
      if (top < (height / 2)) {
        if (left < (width / 2)) {
          $('.' + id).css({'top': top + 15, 'left': left + 15}).fadeIn('fast')
            .animate({width: '600px', height: '250px'});
        } else {
          $('.' + id).css({'top': top + 15, 'right': width - left + 15}).fadeIn('fast')
            .animate({width: '600px', height: '250px'});
        }
      } else {
        if (left < (width / 2)){
          $('.' + id).css({'bottom': height - top + 15, 'left': left + 15})
            .fadeIn('fast').animate({width: '600px', height: '250px'});
        } else {
          $('.' + id).css({'bottom': height - top + 15,
            'right': width - left + 15}).fadeIn('fast')
            .animate({width: '600px', height: '250px'});
        }
      }
    }, 600);
  }, function(){
    clearTimeout(timer);
    $('.' + id).animate({width: '0', height: '0'}).fadeOut('fast');
  });
});
