$(document).ready(function () {
  var navListItems = $('div.setup-panel div a'),
          allWells = $('.setup-content'),
          allNextBtn = $('.nextBtn'),
          allPrevBtn = $('.prevBtn');

  allWells.hide();

  navListItems.click(function (e) {
      e.preventDefault();
      var $target = $($(this).attr('href')),
              $item = $(this);

      if (!$item.hasClass('disabled')) {
          navListItems.removeClass('btn-info').addClass('btn-default');
          $item.addClass('btn-info');
          allWells.hide();
          $target.show();
          $target.find('input:eq(0)').focus();
      }
  });
  
  allPrevBtn.click(function(){
      var curStep = $(this).closest(".setup-content"),
          curStepBtn = curStep.attr("id"),
          prevStepWizard = $('div.setup-panel div a[href="#' + curStepBtn + '"]').parent().prev().children("a");

          prevStepWizard.removeAttr('disabled').trigger('click');
  });

  allNextBtn.click(function(){
      var curStep = $(this).closest(".setup-content"),
          curStepBtn = curStep.attr("id"),
          nextStepWizard = $('div.setup-panel div a[href="#' + curStepBtn + '"]').parent().next().children("a"),
          curInputs = curStep.find("input[type='email'], input[type='text'],input[type='url'], textarea, input[type='radio']"),
          isValid = true;

      $(".form-group").removeClass("has-error");
      $(".batch_sections .form-group").removeClass("has-error-radio");
      for(var i=0; i < curInputs.length; i++){
          if (!curInputs[i].validity.valid){
              console.log("hello")
              isValid = false;
              $(curInputs[i]).closest(".form-group").addClass("has-error");
              $(curInputs[i]).closest(".batch_sections .form-group").addClass("has-error-radio");
          }
      }

      if (isValid)
          nextStepWizard.removeAttr('disabled').trigger('click');
  });

  $('div.setup-panel div a.btn-info').trigger('click');
});