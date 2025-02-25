class ZCL_ZTOPSKIP_DPC_EXT definition
  public
  inheriting from ZCL_ZTOPSKIP_DPC
  create public .

public section.
protected section.

  methods PRODUCTSET_GET_ENTITYSET
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZTOPSKIP_DPC_EXT IMPLEMENTATION.


  METHOD productset_get_entityset.
    DATA: lt_headerdata TYPE TABLE OF bapi_epm_product_header,
          ls_headerdata TYPE bapi_epm_product_header,
          lt_product    TYPE zcl_ztopskip_mpc=>tt_product,
          ls_product    TYPE zcl_ztopskip_mpc=>ts_product,
          lv_top        TYPE i,
          lv_skip       TYPE i.

    CALL FUNCTION 'BAPI_EPM_PRODUCT_GET_LIST'
*  EXPORTING
*    MAX_ROWS                    =
      TABLES
        headerdata = lt_headerdata
*       SELPARAMPRODUCTID           =
*       SELPARAMSUPPLIERNAMES       =
*       SELPARAMCATEGORIES          =
*       RETURN     =
      .

    IF lt_headerdata IS NOT INITIAL.
      LOOP AT lt_headerdata INTO ls_headerdata.
        CLEAR: ls_product.

        ls_product-productid = ls_headerdata-product_id.
        ls_product-typecode  = ls_headerdata-type_code.
        ls_product-category  = ls_headerdata-category.

        APPEND ls_product TO lt_product.
      ENDLOOP.
    ENDIF.

    CLEAR lv_top.
    lv_top = is_paging-top.

    CLEAR lv_skip.
    lv_skip = is_paging-skip.

    IF lv_top IS NOT INITIAL.
      DELETE lt_product FROM ( lv_top + 1 ).
    ENDIF.

    IF lv_skip IS NOT INITIAL.
      DELETE lt_product FROM 1 TO lv_skip.
    ENDIF.

    et_entityset = lt_product.
  ENDMETHOD.
ENDCLASS.
