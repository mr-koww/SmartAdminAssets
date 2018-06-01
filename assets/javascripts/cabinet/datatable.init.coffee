$ ->
  $('table').each ->
    responsiveHelper_dt_basic = undefined
    responsiveHelper_datatable_fixed_column = undefined
    responsiveHelper_datatable_col_reorder = undefined
    responsiveHelper_datatable_tabletools = undefined
    breakpointDefinition =
      tablet: 1024
      phone: 480

    table = this
    $table = $(this)
    $source = $(this).data('source')
    responsive = $(this).data('responsive') || true
    searching = $(this).data('searching') || true
    ordering = $(this).data('ordering') || true
    stateSave = $(this).data('stateSave') || false
    rowReorder = $(this).data('rowReorder') || false

    if ($table != undefined) && ($source != undefined)
      $datatable = $table.DataTable
        language:
          "processing": "Подождите..."
          "search": "<span class='input-group-addon'><i class='glyphicon glyphicon-search'></i></span>"
          "searchPlaceholder": "Поиск"
          "lengthMenu": "Показать _MENU_ записей"
          "info": "Записи с _START_ до _END_ из _TOTAL_ записей"
          "infoEmpty": "Записи с 0 до 0 из 0 записей"
          "infoFiltered": "(отфильтровано из _MAX_ записей)"
          "infoPostFix": ""
          "loadingRecords": "Загрузка записей..."
          "zeroRecords": "Записи отсутствуют."
          "emptyTable": "В таблице отсутствуют данные"
          "paginate":
            "first": "<<"
            "previous": "<"
            "next": ">"
            "last": ">>"
          "aria":
            "sortAscending": ": активировать для сортировки столбца по возрастанию",
            "sortDescending": ": активировать для сортировки столбца по убыванию"
        'responsive': responsive
        'searching': searching
        'ordering': ordering
        'stateSave': stateSave
        'rowReorder': rowReorder
        'processing': false
        'serverSide': true
        'pagingType': 'numbers'
        'lengthMenu': [[10, 25, 50], [10, 25, 50]]
        'autoWidth': true
        "sDom": "<'dt-toolbar'<'col-xs-12 col-sm-6 hidden-xs'f><'col-sm-6 col-xs-12 hidden-xs'<'toolbar'>l>>" +
          't' + '<\'dt-toolbar-footer\'<\'col-sm-6 col-xs-12 hidden-xs\'i><\'col-xs-12 col-sm-6\'p>>'
        'preDrawCallback': ->
          if !responsiveHelper_dt_basic
            responsiveHelper_dt_basic = new ResponsiveDatatablesHelper(this, breakpointDefinition)
          return
        'rowCallback': (nRow) ->
          responsiveHelper_dt_basic.createExpandIcon nRow
          return
        'drawCallback': (oSettings) ->
          responsiveHelper_dt_basic.respond()
        'ajax': $source

      $('.search-input-text').on 'input change select2:select', ->
        i = $(this).attr('data-column')
        v = $(this).val()
        $datatable.columns(i).search(v).draw()
        return

    $table.on 'click', '.details-control', ->
      tr = $(this).closest('tr')
      row = $datatable.row(tr)
      if row.child.isShown()
        row.child.hide()
        tr.removeClass 'shown'
        return
      else
        # TODO: only for visit (need named attr)
        row.child(row.data()[6]).show()
        tr.addClass 'shown'
      return
