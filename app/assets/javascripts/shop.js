$(document).ready(function() {
  var shop_id;
  $.validator.addMethod('shop_valid', function(value, element, regex) {
    return this.optional(element) || regex.test(value);
  }, I18n.t('activerecord.errors.models.shop.attributes.name.without'));
  $('.btn-edit-shop').click(function() {
    shop_id = $(this).data('shop-id');
    $('#edit-shop-modal').on('show.bs.modal', function() {
      var form_edit_shop = document.getElementById('edit_shop_' + shop_id);
      $(form_edit_shop).validate({
        errorPlacement: function (error, element) {
          error.insertBefore(element);
        },
        rules: {
          'shop[name]': {
            required: true,
            maxlength: 50,
            shop_valid: /[a-zA-Z]/
          },
          'shop[description]': {
            required: true,
            maxlength: 250
          }
        },
        messages: {
          'shop[name]': {
            required: I18n.t('activerecord.errors.models.shop.attributes.name.blank'),
            maxlength: I18n.t('activerecord.errors.models.shop.attributes.name.too_long')
          },
          'shop[description]': {
            required: I18n.t('activerecord.errors.models.shop.attributes.description.blank'),
            maxlength: I18n.t('activerecord.errors.models.shop.attributes.description.too_long')
          }
        }
      });
    });
  });
  $('#edit-shop-modal').on('hidden.bs.modal', function() {
    $(this).html('');
  });
  $('#new-shop-modal').on('shown.bs.modal', function() {
    $('#new_shop').validate({
      errorPlacement: function (error, element) {
        error.insertBefore(element);
      },
      rules: {
        'shop[name]': {
          required: true,
          maxlength: 50,
          shop_valid: /[a-zA-Z]/
        },
        'shop[description]': {
          required: true,
          maxlength: 250
        }
      },
      messages: {
        'shop[name]': {
          required: I18n.t('activerecord.errors.models.shop.attributes.name.blank'),
          maxlength: I18n.t('activerecord.errors.models.shop.attributes.name.too_long')
        },
        'shop[description]': {
          required: I18n.t('activerecord.errors.models.shop.attributes.description.blank'),
          maxlength: I18n.t('activerecord.errors.models.shop.attributes.description.too_long')
        }
      }
    });
  });
  $('#new-shop-modal').on('hidden.bs.modal', function() {
    $(this).html('');
  });
});
