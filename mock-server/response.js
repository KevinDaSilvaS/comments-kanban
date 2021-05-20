module.exports = (req, res, next) => {
    console.log(res)
    res.header('X-Hello', 'World')
    next()
}