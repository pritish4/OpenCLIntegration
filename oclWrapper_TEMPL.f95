    module oclWrapper
        implicit none
        integer(8) :: ocl
        integer :: oclNunits
        integer :: oclNthreadsHint
        integer(8), dimension(32) :: oclBuffers
        integer, dimension(32,3) :: oclBufferShapes
        integer :: oclGlobalRange, oclLocalRange
        save
        contains

!        subroutine oclInit(srcstr,srclen,kstr,klen)
        subroutine oclInit(srcstrp,kstrp)   
            integer :: srclen, klen
            character(len=*) :: srcstrp, kstrp
            character(len=:), allocatable :: srcstr, kstr
            srclen = len(srcstrp)
            klen = len(kstrp)
!            character(srclen) :: srcstr 
!            character(klen) :: kstr 
            allocate(character(len=srclen) :: srcstr)
            allocate(character(len=klen) :: kstr)
            srcstr=srcstrp
            kstr=kstrp
!            print *, "source=<",srcstr,">;  kernel=<",kstr,">"
            call oclinitf(ocl, srcstr, srclen, kstr, klen)
        end subroutine

        subroutine oclInitDev(srcstrp,kstrp,devIdx)   
            integer, intent(In) :: devIdx
            integer :: srclen, klen
            character(len=*) :: srcstrp, kstrp
            character(len=:), allocatable :: srcstr, kstr
            srclen = len(srcstrp)
            klen = len(kstrp)
!            character(srclen) :: srcstr 
!            character(klen) :: kstr 
            allocate(character(len=srclen) :: srcstr)
            allocate(character(len=klen) :: kstr)
            srcstr=srcstrp
            kstr=kstrp
!            print *, "source=<",srcstr,">;  kernel=<",kstr,">"
            call oclinitdevf(ocl, srcstr, srclen, kstr, klen, devIdx)
        end subroutine

        subroutine oclInitOpts(srcstrp,kstrp,koptsstrp)   
            integer :: srclen, klen, koptslen
            character(len=*) :: srcstrp, kstrp, koptsstrp
            character(len=:), allocatable :: srcstr, kstr, koptsstr
            srclen = len(srcstrp)
            klen = len(kstrp)
            koptslen = len(koptsstrp)
!            character(srclen) :: srcstr 
!            character(klen) :: kstr 
            allocate(character(len=srclen) :: srcstr)
            allocate(character(len=klen) :: kstr)
            allocate(character(len=koptslen) :: koptsstr)
            srcstr=srcstrp
            kstr=kstrp
            koptsstr = koptsstrp
!            print *, "source=<",srcstr,">;  kernel=<",kstr,">"
            call oclinitoptsf(ocl, srcstr, srclen, kstr, klen, koptsstr, koptslen)
        end subroutine        

        subroutine oclGetMaxComputeUnits(nunits)
            integer :: nunits
            call oclGetMaxComputeUnitsC(ocl,nunits)
            oclNunits=nunits
        end subroutine

        subroutine oclGetNThreadsHint(nthreads)
            integer :: nthreads
            call oclGetNThreadsHintC(ocl,nthreads)
            oclNthreadsHint=nthreads
        end subroutine

        

        subroutine oclMakeFloatArrayReadBuffer(buffer, sz, array)
            integer(8):: buffer
            integer :: sz1d
            integer, dimension(3):: sz
            real,dimension(sz(1),sz(2),sz(3)) :: array
!            real, dimension(size(array)):: array1d
!            array1d = reshape(array,shape(array1d))
            sz1d = size(array)*4 ! x4 because real is 4 bytes
            call oclMakeReadBufferPtrC(ocl,buffer, sz1d, array)
        end subroutine
        subroutine oclMakeFloatArrayReadWriteBuffer(buffer, sz,array)
            integer(8):: buffer
            integer :: sz1d
            integer, dimension(3):: sz
            real,dimension(sz(1),sz(2),sz(3)) :: array
!            real, dimension(size(array)):: array1d
!            print *, 'Reshaping array'
!            array1d = reshape(array,shape(array1d))
            !sz1d = sz(1)*sz(2)*sz(3) ! 
            sz1d=size(array)*4 ! x4 because real is 4 bytes
!            real, allocatable, dimension(:) :: ptr
            !print *, 'sz:', sz
            !print *, 'sz1d:', sz1d
            call oclMakeReadWriteBufferPtrC(ocl,buffer, sz1d,array)
        end subroutine
        subroutine oclMakeIntArrayReadWriteBuffer(buffer, sz,array)
            integer(8):: buffer
            integer :: sz1d
            integer, dimension(3):: sz
            integer,dimension(sz(1),sz(2),sz(3)) :: array
!            real, dimension(size(array)):: array1d
!            print *, 'Reshaping array'
!            array1d = reshape(array,shape(array1d))
            !sz1d = sz(1)*sz(2)*sz(3) ! 
            sz1d=size(array)*4 ! x4 because int is 4 bytes
!            real, allocatable, dimension(:) :: ptr
            !print *, 'sz:', sz
            !print *, 'sz1d:', sz1d
            call oclMakeReadWriteBufferPtrC(ocl,buffer, sz1d,array)
        end subroutine
        subroutine oclMakeIntArrayReadBuffer(buffer, sz, array)
            integer(8):: buffer
            integer :: sz1d
            integer, dimension(3):: sz
            integer,dimension(sz(1),sz(2),sz(3)) :: array
!            real, dimension(size(array)):: array1d
!            array1d = reshape(array,shape(array1d))
            sz1d = size(array)*4 ! x4 because integer is 4 bytes
            !print *, 'sz:', sz
            !print *, 'sz1d:', sz1d
            !integer, allocatable, dimension(:) :: ptr
            call oclMakeReadBufferPtrC(ocl,buffer, sz1d, array)
        end subroutine
!        subroutine oclMakeIntArrayReadWriteBuffer(buffer, sz,ptr)
!            integer(8):: buffer
!            integer :: sz
!            integer, allocatable, dimension(:) :: ptr
!           call oclMakeReadWriteBufferPtrC(ocl,buffer, sz,ptr)
!       end subroutine
        subroutine oclMakeReadBuffer(buffer, sz)
            integer(8):: buffer
            integer :: sz
            call oclMakeReadBufferC(ocl,buffer, sz)
        end subroutine
        subroutine oclMakeReadWriteBuffer(buffer, sz)
            integer(8):: buffer
            integer :: sz
            call oclMakeReadWriteBufferC(ocl,buffer, sz)
        end subroutine
        subroutine oclMakeWriteBuffer(buffer, sz)
            integer(8):: buffer
            integer :: sz
            call oclmakewritebufferc(ocl,buffer, sz)
        end subroutine
        subroutine oclWriteBuffer(buffer, sz,array)
            integer(8):: buffer
            integer :: sz1d
            integer, dimension(3):: sz
            real, dimension(sz(1),sz(2),sz(3)) :: array
!            real, dimension(size(array)):: array1d!
!            array1d = reshape(array,shape(array1d))
            sz1d=size(array)*4 ! x4 because float is 4 bytes
            call oclwritebufferc(ocl,buffer, sz1d,array)
        end subroutine

        subroutine oclWriteBufferById(bufferid, sz,array)
            integer:: bufferid
            integer :: sz1d
            integer, dimension(3):: sz
            real, dimension(sz(1),sz(2),sz(3)) :: array
!            real, dimension(size(array)):: array1d!
!            array1d = reshape(array,shape(array1d))
            sz1d=size(array)*4 ! x4 because float is 4 bytes
            call oclwritebufferc(ocl,oclBuffers(bufferid), sz1d,array)
        end subroutine

      
        subroutine oclSetArrayArg(pos,buf)
            integer :: pos 
            integer(8):: buf
            call oclsetarrayargc(ocl,pos,buf)
        end subroutine
        subroutine oclSetIntArrayArg(pos,buf)
            integer :: pos 
            integer(8):: buf
            call oclsetarrayargc(ocl,pos,buf)
        end subroutine
        subroutine oclSetFloatArrayArg(pos,buf)
            integer :: pos 
            integer(8):: buf
            call oclsetfloatarrayargc(ocl,pos,buf)
        end subroutine
        subroutine oclSetFloatConstArg(pos,constarg)
            integer :: pos
            real :: constarg
            call oclsetfloatconstargc(ocl,pos,constarg)
        end subroutine
        subroutine oclSetIntConstArg(pos,constarg)
            integer :: pos
            integer :: constarg
            call oclsetintconstargc(ocl,pos,constarg)
        end subroutine
!        subroutine oclRun(nargs,argtypes,args)
!            integer :: nargs, argstypes, 
!            call oclrunc(ocl,nargs,argtypes,args)
!        end subroutine
        subroutine runOcl(global,local)
            integer :: global, local
            call runoclc(ocl,global,local)
        end subroutine

        subroutine oclReadBuffer(buffer,sz,array)
            integer(8):: buffer
            integer :: sz1d
            integer, dimension(3):: sz
            real,dimension(sz(1),sz(2),sz(3)) :: array
            real, dimension(size(array)):: array1d
            sz1d = size(array)*4 ! x4 because real is 4 bytes
            call oclreadbufferc(ocl,buffer,sz1d,array1d)
            array = reshape(array1d,shape(array))
        end subroutine

        subroutine oclReadBufferById(bufferid,sz,array)
            integer:: bufferid
            integer :: sz1d
            integer, dimension(3):: sz
            real,dimension(sz(1),sz(2),sz(3)) :: array
            real, dimension(size(array)):: array1d
            sz1d = size(array1d)*4 ! x4 because real is 4 bytes
            call oclreadbufferc(ocl,oclBuffers(bufferid),sz1d,array1d)
            array = reshape(array1d,shape(array))
        end subroutine

        subroutine oclReadRawBuffer(buffer,sz1d,array1d)
            integer(8):: buffer
            integer :: sz1d
            real, dimension(sz1d):: array1d
            call oclreadbufferc(ocl,buffer,sz1d*4,array1d)
        end subroutine

! Note the arg type is 3D array of integers!
        subroutine oclWriteIntBuffer(buffer, sz,array)
            integer(8):: buffer
            integer :: sz1d
            integer, dimension(3):: sz
            integer, dimension(sz(1),sz(2),sz(3)) :: array
!            integer, dimension(size(array)):: array1d!
!            array1d = reshape(array,shape(array1d))
            sz1d=size(array)*4 ! x4 because integer is 4 bytes
            call oclwritebufferc(ocl,buffer, sz1d,array)
        end subroutine

        subroutine oclReadIntBuffer(buffer,sz,array)
            integer(8):: buffer
            integer :: sz1d
            integer, dimension(3):: sz
            integer,dimension(sz(1),sz(2),sz(3)) :: array
            integer, dimension(size(array)):: array1d
            sz1d = size(array1d)*4 ! x4 because integer is 4 bytes
            call oclreadbufferc(ocl,buffer,sz1d,array1d)
            array = reshape(array1d,shape(array))
        end subroutine

        subroutine padRange(orig_range, m)
            integer, intent(InOut) :: orig_range
            integer, intent(In) :: m
            if (mod(orig_range,m) /= 0) then
                orig_range = orig_range + (m - (mod(orig_range,m)))
            end if
        end subroutine

!$GEN WrapperSubs

    end module oclWrapper
