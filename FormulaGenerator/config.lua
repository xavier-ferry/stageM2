--
-- Created by IntelliJ IDEA.
-- User: Xavier
-- Date: 14/06/2016
-- Time: 17:27
-- To change this template use File | Settings | File Templates.
--
generatedFolder = 'generated/'
outputTXTFile = generatedFolder..'generated.txt'
outputMONAFile = generatedFolder..'generated.mona'

outputDEBUGMONAfile = "../luaToMONA/mona/comparaison/debug.mona"
outputCOMPMONAfile = "../luaToMONA/mona/comparaison/comp.mona"

Set=require('Set')
Prop=require('Prop')


require('configs/EX')
gamma = 2

debugON = true