const pool = require('../pool')
const sql = require('../sql/userQuerys')

exports.eventosReservadosPCliente = async (req, res) => {
    try{
        pool.query('call eventos_reservados_clientes()',(err, response) =>{
            if(err) throw err
            if(response[0].length)
                res.json(response[0])
            else
                res.json({eventosReservadosPCliente: false})
            res.end()
        })
    }catch (error){
        return res.json(error)
    }
}

exports.enventosCreadosPAdmin = async (req, res) => {
    try{
        pool.query('call eventos_creados_usuarios()',(err, response) =>{
            if(err) throw err
            if(response[0].length)
                res.json(response[0])
            else
                res.json({eventosReservadosPCliente: false})
            res.end()
        })
    }catch (error){
        return res.json(error)
    }
}

exports.reservasProcesadas = async (req, res) => {
    try{
        pool.query('call reservas_procesadas()',(err, response) =>{
            if(err) throw err
            if(response[0].length)
                res.json(response[0])
            else
                res.json({eventosReservadosPCliente: false})
            res.end()
        })
    }catch (error){
        return res.json(error)
    }
}