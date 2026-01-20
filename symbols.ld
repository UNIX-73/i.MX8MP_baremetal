SECTIONS
{    .platform_info : ALIGN(8)
    {
        __platform_info_start = .;

        __ddr_start = .;
        QUAD(ORIGIN(DDR));

        __ddr_size = .;
        QUAD(LENGTH(DDR));



        __platform_info_end = .;
    } > DDR
}