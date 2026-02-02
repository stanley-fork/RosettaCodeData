module damm_algorithm
   implicit none
   private
   public :: damm_check  ! Expose only the damm_check function to external code

contains

   !---------------------------------------------------------------------
   ! Function: damm_check
   ! Purpose : Validates a digit string using the Damm algorithm
   ! Input   : digit - a character string of numeric digits ('0' to '9')
   ! Output  : is_valid - .TRUE. if the check digit validates, .FALSE. otherwise
   !---------------------------------------------------------------------
   function damm_check(digit) result(is_valid)
      use iso_fortran_env, only: int8  ! Use portable 8-bit integer type
      character(len=*), intent(in) :: digit
      logical :: is_valid
      integer(kind=int8) :: i, d, id

      !------------------------------------------------------------------
      ! Damm operation table: a 10x10 quasigroup matrix used for validation
      ! Note: Fortran stores arrays in column-major order, meaning that
      !       array constructors fill columns first, not rows.
      !       To preserve the intended row-wise layout of the table,
      !       we use TRANSPOSE(RESHAPE(...)) to correct the orientation.
      !------------------------------------------------------------------
      integer(kind=int8), parameter :: optable(0:9, 0:9) = transpose(reshape( &
         [integer(kind=int8) :: &
            0, 3, 1, 7, 5, 9, 8, 6, 4, 2, &  ! Row 0
            7, 0, 9, 2, 1, 5, 4, 8, 6, 3, &  ! Row 1
            4, 2, 0, 6, 8, 7, 1, 3, 5, 9, &  ! Row 2
            1, 7, 5, 0, 9, 8, 3, 4, 2, 6, &  ! Row 3
            6, 1, 2, 3, 0, 4, 5, 9, 7, 8, &  ! Row 4
            3, 6, 7, 4, 2, 0, 9, 5, 8, 1, &  ! Row 5
            5, 8, 6, 9, 7, 2, 0, 1, 3, 4, &  ! Row 6
            8, 9, 4, 5, 3, 6, 2, 0, 1, 7, &  ! Row 7
            9, 4, 3, 8, 6, 1, 7, 2, 0, 5, &  ! Row 8
            2, 5, 8, 1, 4, 3, 6, 7, 9, 0 ], & ! Row 9
         shape=[10, 10]))  ! Reshape into 10x10, then transpose to fix layout

      ! Initialize the interim digit to zero
      id = 0

      ! Loop over each character in the input string
      do i = 1, len(digit)
         ! Convert character to integer digit (ASCII math)
         d = iachar(digit(i:i)) - iachar('0')

         ! Validate that the character is a digit
         if (d < 0 .or. d > 9) then
            error stop 'Invalid input: Not a digit in string'
         end if

         ! Apply Damm algorithm step: lookup in the operation table
         id = optable(id, d)
      end do

      ! Final check: if result is zero, the input is valid
      is_valid = (id == 0)
   end function damm_check

end module damm_algorithm

program test_damm
   use damm_algorithm
   implicit none

   write(*, '(A,L1,A)') 'Damm check for "5724": ', damm_check('5724'), ' (should be .TRUE.)'
   write(*, '(A,L1,A)') 'Damm check for "5727": ', damm_check('5727'), ' (should be .FALSE.)'
   write(*, '(A,L1,A)') 'Damm check for "112946": ', damm_check('112946'), ' (should be .TRUE.)'
   write(*, '(A,L1,A)') 'Damm check for "112949": ', damm_check('112949'), ' (should be .FALSE.)'
end program test_damm
      END
