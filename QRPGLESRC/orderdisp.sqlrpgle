**FREE

ctl-opt Main(mainProc) option(*nodebugio:*srcstmt:*nounref) dftactgrp(*no);


dcl-proc mainProc;
    dcl-f orderdisp workstn sfile(SFL01:RRN01);
    dcl-f orders usage(*input) keyed;

    dcl-s RRN01 int(5) inz(0);

    // Subfile Data structures
    dcl-ds ctl01DS likerec(CTL01:*all);
    dcl-ds sfl01DS likerec(SFL01:*all);
    dcl-ds foot01DS likerec(FOOT01:*output);

    dcl-ds ordersDS likerec(ORDERSF);

    // This refers to the indicators in the display file, you will notice the clear
    // requires that the 30 indicator be on. So this
    ctl01DS.in30 = *on;
    write CTL01 ctl01DS;
    ctl01DS.in30 = *off;

    setll *start orders;
    dou RRN01 = 9999;
        read orders ordersDS;

        if %eof(orders);
            leave;
        endif;
        RRN01 += 1;

        sfl01DS.ORDERID = ordersDS.ORDERID;
        sfl01DS.CUSTID = ordersDS.CUSTID;
        sfl01DS.ITEMNAME = ordersDS.ITEMNAME;
        sfl01DS.QUANTITY = ordersDS.QUANTITY;
        sfl01DS.STATUS = ordersDS.STATUS;
        write SFL01 sfl01DS;
    enddo;

    // Subfile display and subfile end indicator
    if RRN01 > 0;
        ctl01DS.in31 = *on;
        ctl01DS.in33 = *on;
    endif;

    // Subfile display control comes on either way
    ctl01DS.in32 = *on;
    write FOOT01 foot01DS;

    // The actual running of the program
    dou ctl01DS.in03 = *on;
        exfmt CTL01 ctl01DS;

        readc SFL01 sfl01DS;
        dow not %eof(orderdisp);
            if sfl01DS.USEROPT = '2';
                editOrder(sfl01DS.ORDERID);
            endif;
            readc SFL01 sfl01DS;
        enddo;

        
    enddo;


    return;
end-proc;

// TODO: Want to use sql in this 
dcl-proc editOrder;
    dcl-pi *n;
        orderNum char(5);
    end-pi;

    dcl-f orderdisp workstn;
    
    dcl-ds editrecDS likerec(EDITREC:*all);
    dcl-ds win01DS likerec(WIN01:*all);

    dcl-s itemName char(20);
    dcl-s quantity int(5);
    dcl-s status char(20); 

    editrecDS.ORDERID = orderNum;

    write WIN01 win01DS;

    dou editrecDS.in03;
        exfmt EDITREC editrecDS;

        if editrecDS.in09;
            itemName = %trim(editrecDS.itemName);
            quantity = editrecDS.quantity;
            status = %trim(editrecDS.status);

            exec sql    
            update orders
            set
                itemname = case when :itemName <> '' then :itemName else itemname end,
                quantity = case when :quantity <> 0 then :quantity else quantity end,
                status = case when :status <> '' then :status else status end
            where orderid = :orderNum;
            
            // Checks for errors if needed. 
            // if sqlcode <> 0;
            // dsply ('SQL Error:' + %char(sqlcode));
            // endif;
        endif;
    enddo;

    return;
end-proc;
