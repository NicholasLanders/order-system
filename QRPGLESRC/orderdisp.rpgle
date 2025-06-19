**FREE

ctl-opt Main(mainProc) option(*nodebugio:*srcstmt:*nounref);


dcl-proc mainProc;
    dcl-f orderdisp workstn sfile(SFL01:RRN01);
    dcl-f orders usage(*input) keyed;

    dcl-s RRN01 int(5) inz(0);

    // Subfile Data structures
    dcl-ds ctl01DS likerec(CTL01:*output);
    dcl-ds sfl01DS likerec(SFL01:*output);
    dcl-ds foot01DS likerec(FOOT01:*output);

    dcl-ds ordersDS likerec(ORDERSF);

    // This refers to the indicators in the display file, you will notice the clear
    // requires that the 30 indicator be on. So this
    *in30 = *on;
    write CTL01 ctl01DS;
    *in30 = *off;

    setll *start orders;
    dou RRN01 = 9999;
        read orders ordersDS;

        if %eof(orders);
            leave;
        endif;
        RRN01 += 1;
        write SFL01 sfl01DS;
    enddo;

    if RRN01 > 0;
        *in31 = *on;
        *in32 = *on;
    endif;

    *in33 = *on;
    write FOOT01 foot01DS;

    // TODO: Why does this work? 
    dou *in(03);
        exfmt CTL01 ctl01DS;
    enddo;


    return;
end-proc;
