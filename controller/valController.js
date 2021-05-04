const pool = require('../pool')
const tocken = '66b86305034d4827fce965b4e246ff62545c6d4db3701138cca4e1b648583ec6'

exports.buscarEntrada = async (req, res) => {
    var data = req.body
    try{
        if(data.tocken == tocken){
            pool.query('call buscar_entrada("'+data.codigoEntrada+'")',(err, response) =>{
                if(err) throw err
                if(response[0].length){
                    var horaEvento
                    response[0].forEach(entrada => {
                        horaEvento = parseInt(entrada.hora) + 5
                    });
                        var hoy = new Date()
                        var horaEvaluar = hoy.getHours()
                        console.log(horaEvaluar + " " + horaEvento)
                        if(horaEvaluar <= horaEvento){
                            res.json(response[0])
                        }else{
                            res.json({error:"Lo sentimos, ya no es posible procesar la entrada"})        
                        }
                }else{
                    res.json({error:"No se encontro ninguna entrada"})
                }
                res.end()
            })
        }else{
            res.json({error: 'No tiene acceso a esta pagina'})
        }
        
    }catch (error){
        return res.json(error)
    }
}

exports.procesarReservacion = async (req, res) => {
    var data = req.body
    try{
        if(data.tocken == tocken){
            pool.query('call procesar_reserva("'+data.codigoEntrada+'")',(err, response2) =>{
                if(err) throw err
                if(response2){
                    res.json({respuesta: 'correcto'})
                }
                res.end()
            })
        }else{
            res.json({error: 'No tiene acceso a esta pagina'})
        }
    }catch (error){
        return res.json(error)
    }
}