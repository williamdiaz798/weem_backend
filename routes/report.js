const express = require('express')
const router = express.Router()

const { eventosReservadosPCliente, enventosCreadosPAdmin,reservasProcesadas } = require('../controller/reportController')

router.get('/enventosCreadosPAdmin', enventosCreadosPAdmin)
router.get('/eventosReservadosPCliente', eventosReservadosPCliente)
router.get('/reservasProcesadas', reservasProcesadas)


module.exports = router