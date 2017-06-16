$(document).ready(function() {
  $('#step2').on("click", "button.btnBack", function(){
    $('.disabl_step1').removeClass("disabled");
    $('.disabl_step2').addClass( "disabled" );
  });

  $('#checkbox').on('click', function(){
    $('input:checkbox').not(this).prop('checked', this.checked);
  });

  $('.btnNext').on('click', function() {
    var shopId = $('#shop-id').val();
    $.ajax({
      url : '/dashboard/shops/' + shopId + '/accepted_order_products',
      type: 'GET',
      dataType: 'json',
      success: function(data) {
        content = "<div class='panel panel-default' id='tabs'>"+
          "<div class='panel-body'> <div class='dropdown action'>"+
          "<button class='list btn btn-primary btn-action btnPrev step1 btnBack'"+
          "id='tab-2' href='#step1' data-toggle='tab'>Back</button>"+
          "<a class='list btn btn-success btn-action pull-right'"+
          "href='/dashboard/shops/" + shopId +
          "/order_products'>Done</a></div></div></div>"+
          "<table class='table table-bordered' <thead><tr> <th>ID" +
          "</th> <th>Productname</th> <th>Quantity</th> <th>Price (VND)</th></tr>" +
          "</thead> <tbody>";
        var total = 0, price = 0;
        for (var i = 0; i < data.length; i++) {
          total += parseFloat(data[i].price)
          price = parseFloat(data[i].price).toFixed(2).replace(/./g, function(c, i, a) {
            return i && c !== "." && ((a.length - i) % 3 === 0) ? ',' + c : c;
          })
          var index = i + 1;
          var row = "<tr><td>" + index + " </td> <td> <a href=" +
            "/dashboard/shops/" + shopId + "/products/" + data[i].product_id +
            "?order_product_id="+
            data[i].id+">" + data[i].name  + "</a></td><td>" + data[i].quantity
            + "</td><td>" +
            price +"</td></tr>"
          content += row;
        }
        total = total.toFixed(2).replace(/./g, function(c, i, a) {
          return i && c !== "." && ((a.length - i) % 3 === 0) ? ',' + c : c;
        })
        var total2 = "Total: " + total.toString() + " VND";
        var row = "<tr><td>" + "" + " </td> <td> <a href=" +
          "/dashboard/shops/" + "" + "/products/" + "" +
          "?order_product_id="+
          ""+">" + ""  + "</a></td><td>" + ""
          + "</td><td><strong class='tdtd'>" +
          total2 +"</strong></td></tr>"
        content += row;
        content += '</tbody></table>'
        $('.disabl_step2').removeClass("disabled");
        $('.disabl_step1').addClass( "disabled" );
        $('#step2').html(content);
      },
      error: function(error_message) {
        Console.log('error: ' + error_message);
      }
    });
  });

  $('.status-order').change(function() {
    itemId = $(this).parent().parent().children()[0].value;
    var selectedValue = $( '#status-order-'+ itemId +' option:selected' ).text()
    var classes = ['label-info', 'label-warning', 'label-danger', 'label-primary'];
    var actions = ['pending', 'accepted', 'rejected', 'done'];
    var shopId = $('#shop-id').val();
    $.ajax({
      url : '/dashboard/shops/' + shopId + '/order_products/' + itemId,
      type: 'PUT',
      dataType: 'json',
      data: {
        order_product: {
          status: selectedValue
        }
      },
      success: function() {
        var klass = '.order-product-status-' + itemId + ' span';
        $(klass).text(selectedValue);
        var currentClass = $(klass).attr('class').split(' ')[1];
        $(klass).removeClass(currentClass).addClass(classes[actions.indexOf(selectedValue)]);
      },
      error: function(error_message) {
        Console.log('error: ' + error_message);
      }
    });
  });

  $('.button').on('click', function() {
    var idOrders = [];
    var shopId = $('#shop-id').val();
    action = $(this).val();
    $('.orders-hidden').each(function (index, obj) {
      if ($(obj).find('input:checkbox').prop('checked')) {
        idOrders.push(($(obj).children()[0]).value);
      }
      else {
        idOrders.push(($(obj).children()[0]).value);
      }
    });
    var idItems = [];
    var classes = ['label-info', 'label-warning', 'label-danger', 'label-primary'];
    var actions = ['pending', 'accepted', 'rejected', 'done'];
    for (i = 0; i < idOrders.length; i++) {
      $('#order-' + idOrders[i] + ' table tbody tr').each(function() {
        id = $(this).children()[0].value;
        if ($('#checkbox-' + id).is(':checked')) {
         idItems.push(id);
       }
     });
    }

    $.each(idOrders, function( index, value ) {
      $.ajax({
        type: 'PUT',
        url : '/dashboard/shops/' + shopId + '/orders/' + value,
        dataType: 'json',
        data: {
          order: {
            status: action
          }
        },
        success: function(data) {
          var klass = '#status-' + value + ' span';
          $(klass).text(action);
          var currentClass = $(klass).attr('class').split(' ')[1];
          $(klass).removeClass(currentClass).addClass(classes[actions.indexOf(action)]);
          if (action == 'rejected') {
            $('.step2-new').hide();
            document.location = "/dashboard/shops/" + shopId + "/order_products"
          }
          else{
            $('.step2-new').show();
          }
        },
        error: function(error_message) {
          Console.log('error: ' + error_message);
        }
      });
    });
    $.each(idItems, function( index, value ) {
      $.ajax({
        type: 'PUT',
        url : '/dashboard/shops/' + shopId + '/order_products/' + value,
        dataType: 'json',
        data: {
          order_product: {
            status: action
          }
        },
        success: function(data) {
          var klass = '.order-product-status-' + value + ' span';
          $(klass).text(action);
          var currentClass = $(klass).attr('class').split(' ')[1];
          $(klass).removeClass(currentClass).addClass(classes[actions.indexOf(action)]);
        },
        error: function(error_message) {
          Console.log('error: ' + error_message);
        }
      });
    });
  });

  $(document).on('click', '.single-action', function(){
    kclass = '.order-product-status-' + order_product_id;
    var action = $(this).data('action');
    var order_id = $(this).parents('.list_order_item').data('id');
    var order_class = '#order_item_' + order_id;
    var status_now = $(kclass).data('status')
    if(status_now == action)
      return;
    else {
      var order_product_id =  $(this).data('id');
      var shopId = $('#shop-id').val();
      $.ajax({
        type: 'PUT',
        url : '/dashboard/shops/' + shopId + '/order_products/' + order_product_id,
        dataType: 'json',
        data: {
          order_product: {
            status: action,
            order_id: order_id
          },
          type: 1
        },
        success: function(data) {
          kclass = '.order-product-status-' + order_product_id;
          if(data.status === 'rejected')
            $(kclass).html('<span class="label label-danger">' + $('#shop-id').data('rej') + '</span>');
          else
            $(kclass).html('<span class="label label-warning">' + $('#shop-id').data('acc') + '</span>');
          $(kclass).attr('data-status', data.status);
          $(order_class).find('.value_pending').html(data.count_pending);
          $(order_class).find('.value_accepted').html(data.count_accepted);
          $(order_class).find('.value_rejected').html(data.count_rejected);
          render_item_packing(data.list_packing);
        },
        error: function(error_message) {
          alert(error_message);
        }
      });
    }
  });
  $(document).on('click', '.single-action-all', function(){
    var action = $(this).data('action');
    var order_id = $(this).parents('.list_order_item').data('id');
    var shopId = $('#shop-id').val();
    var order_class = '#order_item_' + order_id;
    $.ajax({
      type: 'PUT',
      url : '/dashboard/shops/' + shopId + '/order_products/0',
      dataType: 'json',
      data: {
        order_product: {
          status: action,
          order_id: order_id
        },
        type: 0
      },
      success: function(data) {
        if(data.status === 'rejected')
          $(order_class + ' .content table tbody tr').children('.class_status_order_product').html('<span class="label label-danger">' + $('#shop-id').data('rej') + '</span>');
        else
          $(order_class + ' .content table tbody tr').children('.class_status_order_product').html('<span class="label label-warning">' + $('#shop-id').data('acc') + '</span>');
        $(order_class).find('.value_pending').html(data.count_pending);
        $(order_class).find('.value_accepted').html(data.count_accepted);
        $(order_class).find('.value_rejected').html(data.count_rejected);
        render_item_packing(data.list_packing);
      },
      error: function(error_message) {
        alert(error_message);
      }
    });
  });
});

function render_item_packing(data){
  var html = '';
  var total_quantity = 0;
  var total_money = 0;
  $.each(data, function( index, value ) {
    total_money += value.price;
    total_quantity += value.quantity;
    html +=  '<tr><td>' + value.name + '</td><td class="center">' +
      value.quantity +'</td><td class="right">' + value.price + '.0</td></tr>'
  });
  $('.info_total_packing_product').html(total_quantity);
  $('.info_total_packing_categorie').html(data.length);
  $('.info_total_packing_money').html(total_money + '.0');
  $('#list_packing').html(html);
};

$(document).on('click', '.step2', function() {
  $('#stars').removeClass('btn-primary').addClass('btn-default');
  $('#favorites').removeClass('btn-default').addClass('btn-primary');
});

$(document).on('click', '.step1', function() {
  $('#favorites').removeClass('btn-primary').addClass('btn-default');
  $('#stars').removeClass('btn-default').addClass('btn-primary');
});

$(document).ready(function(){
  $('.step1').click();
});

$(document).ready(function() {
  $('#id_btn_done').click(function() {
   $('.done-action').hide();
  });
});

$('#myModal').on('shown.bs.modal', function () {
  $('#myInput').focus()
});
