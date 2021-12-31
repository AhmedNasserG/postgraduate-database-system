const express = require('express');
const toast = require('../utilities/toast');
const router = express.Router();
const userProcedures = require('../procedures/userProcedures');

router.post('/',function(req,res){
    const id = req.session.userId
    const mobile = req.body.mobile
    userProcedures.addMobile(id,mobile).then(response =>{
        toast.showToast(req,'success','Mobile added successfully')
        res.redirect('back')
    }).catch(err =>{
        console.log(err)
        toast.showToast(req,'error','same mobile added ')
        res.redirect('back')
    })

})

module.exports = router;
