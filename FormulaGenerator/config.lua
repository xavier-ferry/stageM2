--
-- Created by IntelliJ IDEA.
-- User: Xavier
-- Date: 14/06/2016
-- Time: 17:27
-- To change this template use File | Settings | File Templates.
--

Formule = 'EG'


generatedFolder = 'generated/'
outputTXTFile = generatedFolder..'generated.txt'
outputMONAFile = generatedFolder..Formule..'.mona'
outputSuccIndice = 0
outputSucc = generatedFolder .. 'succ'.. tostring(outputSuccIndice)..'.mona'


outputDEBUGMONAfile = "../luaToMONA/mona/comparaison/debug.mona"
outputCOMPMONAfile = "../luaToMONA/mona/comparaison/comp.mona"
fonction_choixTransition = 'transition'
prefix_fonction = ''

Set=require('Set')
Prop=require('Prop')

require('configs/succ')
require('configs/'..Formule)
gamma = 2

debugON = false



