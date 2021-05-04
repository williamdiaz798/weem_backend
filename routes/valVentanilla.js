const express = require('express')
const router = express.Router()

const { 
    buscarEntrada,
    procesarReservacion
} = require('../controller/valController')

router.post('/buscarEntrada/', buscarEntrada)
router.post('/procesarReservacion/', procesarReservacion)
module.exports = router