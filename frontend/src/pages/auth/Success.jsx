
import React from 'react'
import { Link } from 'react-router-dom'


const Success = () => {
  return (
     <main className="bg-white grid justify-center items-center overflow-y-auto hide-scrollbar py-10 md:px-11 px-12  rounded-3xl  ">
      <form className="gap-5 flex flex-col items-center md:w-[450px] w-full">

        
      <h3 className='font-inter font-semibold text-[32px] text-[#333333] text-center '>Password Updated Successfully!</h3>
      <p className='font-inter  text-[#333333] text-center '>Your new password has been saved. You can now continue securely..</p>

      

     
      


     <Link to='/auth/login' className='w-[50%]'>
     
      <button className='bg-[#F6A62D] text-[#ffffff]  text-xl w-full  py-3 rounded-lg cursor-pointer mt-5'>
        Log In
      </button>
     </Link> 

     
      
      </form>

    </main>
  )
}

export default Success