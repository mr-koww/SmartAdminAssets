$ ->
  $('.dropify').dropify
    messages:
      'default': 'Перетащите или загрузите фотографию'
      'replace': 'Перетащите или загрузите фотографию для замены'
      'remove': 'Удалить'
      'error': 'Ошибка загрузки'
    error:
      'fileSize': 'Файл слишком большой ({{ value }} максимум).'
      'fileExtension': 'На фото можно поставить только форматы: {{ value }}'


  # extend validator messages (RU)
  jQuery.extend jQuery.validator.messages,
    required: 'Обязательное поле.'
    email: 'Введите корректный email.'


  # validate form
  $form = $('form').validate(
    errorClass: 'invalid'
    errorElement: 'em'
    highlight: (element) ->
      $(element).parent().removeClass('state-success').addClass 'state-error'
      $(element).removeClass 'valid'
      return
    unhighlight: (element) ->
      $(element).parent().removeClass('state-error').addClass 'state-success'
      $(element).addClass 'valid'
      return
    errorPlacement: (error, element) ->
      error.insertAfter element.parent()
      return
  )


  # add mask forinput
  if $.fn.mask
    $('[data-mask]').each ->
      $this = $(this)
      mask = $this.attr('data-mask') or 'error...'
      mask_placeholder = $this.attr('data-mask-placeholder') or '_'
      $this.mask mask, placeholder: mask_placeholder
      $this = null
      return


  # add calendar for input
  $('.datepicker').each ->
    $this = $(this)
    minDate = $this.data('minDate') or '-10'
    maxDate = $this.data('maxDate') or '+10'
    #    alert maxDate
    $this.datepicker
      dateFormat: 'yy-mm-dd'
      language: 'ru'
      prevText: '<i class="fa fa-chevron-left"></i>'
      nextText: '<i class="fa fa-chevron-right"></i>'
      changeMonth: true
      changeYear: true
      yearRange: "-100:+100"
      minDate: minDate
      maxDate: maxDate

  # add clock for input
  $('.clockpicker').clockpicker()

  # init select2 plugin for input
  $('.select2').select2
    theme: 'bootstrap'
    language: 'ru'
    delay: 0
    minimumResultsForSearch: -1


  # init menu
  $('nav ul').jarvismenu
    accordion: true
    speed: 235
    closedSign: '<em class="fa fa-plus-square-o"></em>'
    openedSign: '<em class="fa fa-minus-square-o"></em>'

  $('#toggle-menu').on 'click', (e) ->
    $('body').toggleClass 'hidden-menu'
    e.preventDefault()
    return
