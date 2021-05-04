const express = require('express')
const router = express.Router()

const { 
    reservacionesPorCliente,
    reservacionDetalle,
    reservacionesPorClienteTodas,
    reservacionEliminar,
    reservar
} = require('../controller/clientController')

router.post('/reservacionesPorCliente/', reservacionesPorCliente)
router.post('/reservacionesPorClienteTodas/', reservacionesPorClienteTodas)
router.post('/reservacionDetalle/', reservacionDetalle)
router.post('/reservacionEliminar/', reservacionEliminar)
router.post('/reservar/', reservar)
module.exports = router