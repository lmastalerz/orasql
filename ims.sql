/******************************************************************************
* File           ims.sql
* Description    Script displays Oracle In-Memory segments
* Parameteres    
*    segment_name: name of the segment to display or part of it 
*    topn: display only n top segments sorted by size in IM store
* 
* History
*    Date        Change
*    13/04/2016  Initial version 
******************************************************************************/

COL owner FOR A20
COL segment_name FOR A30 HEAD NAME
COL partition_name FOR A30 HEAD PARTITION
COL inmemory_priority FOR A20 HEAD PRIORITY
COL inmemory_duplicate FOR A20 HEAD DUPLICATE 
COL compression FOR 99D999 HEAD COMPRESSION
SELECT * 
FROM (SELECT ims.inst_id
           , ims.owner
           , ims.segment_name 
           , ims.partition_name
           , ims.populate_status status
           , ims.inmemory_priority
           , ims.inmemory_duplicate
           , ims.inmemory_compression
           , ims.inmemory_size/1024/1024 im_mb
           , ims.bytes / 1024 / 1024 disk_mb
           , ims.bytes_not_populated / 1024 / 1024 not_populated_mb           
           , ROUND((ims.inmemory_size/ims.bytes), 2) compression
      FROM   gv$im_segments ims
      WHERE  ims.segment_name LIKE '%' || '&segment_name' || '%'
      ORDER BY ims.inmemory_size DESC )
WHERE rownum <= NVL('&topn', '10'); 