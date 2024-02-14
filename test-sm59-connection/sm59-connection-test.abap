*&---------------------------------------------------------------------*
*& Report Z_TEST_ECOSIO_CONN
*&---------------------------------------------------------------------*
*& Sample report to test connectivity of an SM59 HTTP connection
*&---------------------------------------------------------------------*
REPORT z_test_ecosio_conn.

DATA: lv_http_dest TYPE rfcdest VALUE 'CHANGE-ME'. "Put the name of the added SM59 HTTP destination here.

* Add your APP KEY here. 
DATA: lv_app_key_ecosio TYPE string VALUE 'CHANGE-ME'.


DATA: lv_http_rc TYPE string.
DATA: lv_code TYPE i.
DATA: lv_reason TYPE string.
DATA: o_client TYPE REF TO if_http_client.

TRY.
    cl_http_client=>create_by_destination(
       EXPORTING destination = lv_http_dest
       IMPORTING client      = o_client ).

    o_client->request->set_method(  if_http_request=>co_request_method_get ).
    
    o_client->request->set_header_field(
               EXPORTING
                 name  = 'X-APP-KEY'
                 value = lv_app_key_ecosio
                ).

    o_client->send( ).

    o_client->receive( ).

    o_client->response->get_status( IMPORTING
                                      code   = lv_code
                                      reason = lv_reason ).
    IF lv_code = 200.
      DATA(lv_json) = o_client->response->get_cdata( ).
      WRITE 'Request successful.'.
    ELSE.
      WRITE: / 'Unable to authenticate - error: ', lv_code, 'Details: ', lv_reason.
    ENDIF.

    o_client->close( ).

  CATCH cx_root INTO DATA(e_txt).
    WRITE: / e_txt->get_text( ).
ENDTRY.