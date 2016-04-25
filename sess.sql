/******************************************************************************
* File			sess.sql
* Description	Script displays Oracle sessions 
* Parameteres	
*	active_only_YN: display only active sessions 
* 
* History
* 	Date		Change
*	26/02/2016	Initial version 
*	25/04/2016	Adding RAC instance ID
******************************************************************************/

 COL bs FOR 9999
 COL obj FOR a35
 COL username FOR A20
 COL action FOR A15
 COL sid FOR 9999
 COL inst_id FOR 9 HEAD I
 COL serial# FOR 99999 HEAD SER#
 COL osuser FOR A10
 COL plsql_obj FOR A20
 COL plsql_entry_obj FOR A20
 COL last_call_et FOR 9999999 HEAD CALLET
 COL object_name FOR A30
 COL p1 FOR A15
 COL event FOR A35
 COL resource_consumer_group FOR A20
 SELECT s.inst_id
      , s.sid
      , s.serial#
      , s.username
      , s.osuser
      , s.sql_id
      , s.status
      , a.name action
      , o4.object_name ||
        NVL2(o4.subobject_name
           , '(' || o4.subobject_name || ')'
           , NULL) obj
      , s.event
      , s.resource_consumer_group
      , last_call_et
      , s.blocking_session bs
  FROM  gv$session s
  LEFT JOIN audit_actions a
  ON    (s.command = a.action)
  LEFT JOIN dba_objects o
  ON    (o.object_id = s.row_wait_obj#)
  LEFT JOIN dba_objects o2
  ON    (s.plsql_object_id = o2.object_id)
  LEFT JOIN dba_objects o3
  ON    (s.plsql_entry_object_id = o3.object_id)
  LEFT JOIN dba_objects o4
  ON    (o4.object_id = s.row_wait_obj#)
  WHERE s.status <> DECODE(UPPER(NVL('&active_only_YN', 'Y')), 'Y', 'INACTIVE', 'dummy')
  AND   username IS NOT NULL
  AND   s.sid <> SYS_CONTEXT('USERENV', 'SID')
  ORDER BY status, sid, username;
