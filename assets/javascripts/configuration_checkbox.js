$(function(){
    $('.uniq_check').change(function(){
      var checkbox = $(this),
          klass = checkbox.attr('class').split(/\s+/);
      klass = klass[klass.length - 1];
      $('.'+klass).not(checkbox).prop('checked',false);
    });
});  