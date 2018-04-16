module Web3.Eth exposing (..)

import BigInt exposing (BigInt)
import Http
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode
import Task exposing (Task)
import Web3.Types exposing (..)
import Web3.Eth.Encode as Encode
import Web3.Eth.Decode as Decode
import Web3.Decode as Decode
import Web3.Encode as Encode
import Web3.RPC as RPC


-- ETH


call : HttpProvider -> TxParams a -> Task Http.Error a
call ethNode txParams =
    callAtBlock ethNode Latest txParams


callAtBlock : HttpProvider -> BlockId -> TxParams a -> Task Http.Error a
callAtBlock ethNode blockId txParams =
    RPC.buildRequest
        { url = ethNode
        , method = "eth_call"
        , params = [ Encode.callParams txParams, Encode.blockId blockId ]
        , decoder = txParams.decoder
        }


send : TxParams a -> Send
send { to, from, gas, gasPrice, value, data, nonce } =
    { to = to
    , from = from
    , gas = gas
    , gasPrice = gasPrice
    , value = value
    , data = data
    , nonce = nonce
    }


getTransactionByHash : HttpProvider -> TxHash -> Task Http.Error Tx
getTransactionByHash ethNode txHash =
    RPC.buildRequest
        { url = ethNode
        , method = "eth_getTransactionByHash"
        , params = [ Encode.txHash txHash ]
        , decoder = Decode.tx
        }


getTransactionReceipt : HttpProvider -> TxHash -> Task Http.Error TxReceipt
getTransactionReceipt ethNode txHash =
    RPC.buildRequest
        { url = ethNode
        , method = "eth_getTransactionReceipt"
        , params = [ Encode.txHash txHash ]
        , decoder = Decode.txReceipt
        }


getLogs : HttpProvider -> LogFilter -> Task Http.Error (List Log)
getLogs ethNode logFilter =
    RPC.buildRequest
        { url = ethNode
        , method = "eth_getLogs"
        , params = [ Encode.logFilter logFilter ]
        , decoder = Decode.list Decode.log
        }



-- WEB3


clientVersion : HttpProvider -> Task Http.Error String
clientVersion ethNode =
    RPC.buildRequest
        { url = ethNode
        , method = "web3_clientVersion"
        , params = []
        , decoder = Decode.string
        }



-- NET


netVersion : HttpProvider -> Task Http.Error NetworkId
netVersion ethNode =
    RPC.buildRequest
        { url = ethNode
        , method = "net_version"
        , params = []
        , decoder = Decode.netVersion
        }


netListening : HttpProvider -> Task Http.Error Bool
netListening ethNode =
    RPC.buildRequest
        { url = ethNode
        , method = "net_listening"
        , params = []
        , decoder = Decode.bool
        }


netPeerCount : HttpProvider -> Task Http.Error Int
netPeerCount ethNode =
    RPC.buildRequest
        { url = ethNode
        , method = "net_peerCount"
        , params = []
        , decoder = Decode.stringInt
        }



-- ETH


protocolVersion : HttpProvider -> Task Http.Error Int
protocolVersion ethNode =
    RPC.buildRequest
        { url = ethNode
        , method = "eth_protocolVersion"
        , params = []
        , decoder = Decode.hexInt
        }


syncing : HttpProvider -> Task Http.Error (Maybe SyncStatus)
syncing ethNode =
    RPC.buildRequest
        { url = ethNode
        , method = "eth_syncing"
        , params = []
        , decoder = Decode.syncStatus
        }


coinbase : HttpProvider -> Task Http.Error Address
coinbase ethNode =
    RPC.buildRequest
        { url = ethNode
        , method = "eth_coinbase"
        , params = []
        , decoder = Decode.address
        }


mining : HttpProvider -> Task Http.Error Bool
mining ethNode =
    RPC.buildRequest
        { url = ethNode
        , method = "eth_mining"
        , params = []
        , decoder = Decode.bool
        }


hashrate : HttpProvider -> Task Http.Error Int
hashrate ethNode =
    RPC.buildRequest
        { url = ethNode
        , method = "eth_hashrate"
        , params = []
        , decoder = Decode.hexInt
        }


gasPrice : HttpProvider -> Task Http.Error BigInt
gasPrice ethNode =
    RPC.buildRequest
        { url = ethNode
        , method = "eth_gasPrice"
        , params = []
        , decoder = Decode.bigInt
        }


accounts : HttpProvider -> Task Http.Error (List Address)
accounts ethNode =
    RPC.buildRequest
        { url = ethNode
        , method = "eth_accounts"
        , params = []
        , decoder = Decode.list Decode.address
        }


blockNumber : HttpProvider -> Task Http.Error Int
blockNumber ethNode =
    RPC.buildRequest
        { url = ethNode
        , method = "eth_blockNumber"
        , params = []
        , decoder = Decode.hexInt
        }


getBalance : HttpProvider -> Address -> Task Http.Error BigInt
getBalance ethNode address =
    getBalanceAtBlock ethNode Latest address


getBalanceAtBlock : HttpProvider -> BlockId -> Address -> Task Http.Error BigInt
getBalanceAtBlock ethNode blockId address =
    RPC.buildRequest
        { url = ethNode
        , method = "eth_getBalance"
        , params = [ Encode.address address, Encode.blockId blockId ]
        , decoder = Decode.bigInt
        }


getStorageAt : HttpProvider -> Address -> Int -> Task Http.Error BigInt
getStorageAt ethNode address index =
    getStorageAtBlock ethNode Latest address index


getStorageAtBlock : HttpProvider -> BlockId -> Address -> Int -> Task Http.Error BigInt
getStorageAtBlock ethNode blockId address index =
    RPC.buildRequest
        { url = ethNode
        , method = "eth_getStorageAt"
        , params = [ Encode.address address, Encode.hexInt index, Encode.blockId blockId ]
        , decoder = Decode.bigInt
        }


getTxCount : HttpProvider -> Address -> Task Http.Error Int
getTxCount ethNode address =
    getTxCountAtBlock ethNode Latest address


getTxCountAtBlock : HttpProvider -> BlockId -> Address -> Task Http.Error Int
getTxCountAtBlock ethNode blockId address =
    RPC.buildRequest
        { url = ethNode
        , method = "eth_getTransactionCount"
        , params = [ Encode.address address, Encode.blockId blockId ]
        , decoder = Decode.hexInt
        }


getBlockTxCountByHash : HttpProvider -> BlockHash -> Task Http.Error Int
getBlockTxCountByHash ethNode blockHash =
    RPC.buildRequest
        { url = ethNode
        , method = "eth_getBlockTransactionCountByHash"
        , params = [ Encode.blockHash blockHash ]
        , decoder = Decode.hexInt
        }


getBlockTxCountByNum : HttpProvider -> Int -> Task Http.Error Int
getBlockTxCountByNum ethNode blockNumber =
    RPC.buildRequest
        { url = ethNode
        , method = "eth_getBlockTransactionCountByNumber"
        , params = [ Encode.hexInt blockNumber ]
        , decoder = Decode.hexInt
        }


getUncleCountByHash : HttpProvider -> BlockHash -> Task Http.Error Int
getUncleCountByHash ethNode blockHash =
    RPC.buildRequest
        { url = ethNode
        , method = "eth_getUncleCountByBlockHash"
        , params = [ Encode.blockHash blockHash ]
        , decoder = Decode.hexInt
        }


getUncleCountByNum : HttpProvider -> Int -> Task Http.Error Int
getUncleCountByNum ethNode blockNumber =
    RPC.buildRequest
        { url = ethNode
        , method = "eth_getUncleCountByBlockNumber"
        , params = [ Encode.hexInt blockNumber ]
        , decoder = Decode.hexInt
        }


getCode : HttpProvider -> Address -> Task Http.Error String
getCode ethNode address =
    getCodeAtBlock ethNode Latest address


getCodeAtBlock : HttpProvider -> BlockId -> Address -> Task Http.Error String
getCodeAtBlock ethNode blockId address =
    RPC.buildRequest
        { url = ethNode
        , method = "eth_getCode"
        , params = [ Encode.address address, Encode.blockId blockId ]
        , decoder = Decode.string
        }


sign : HttpProvider -> Address -> String -> Task Http.Error String
sign ethNode address data =
    RPC.buildRequest
        { url = ethNode
        , method = "eth_sign"
        , params = [ Encode.address address, Encode.string data ]
        , decoder = Decode.string
        }


sendTx : HttpProvider -> Send -> Task Http.Error TxHash
sendTx ethNode txParams =
    RPC.buildRequest
        { url = ethNode
        , method = "eth_sendTransaction"
        , params = [ Encode.sendParams txParams ]
        , decoder = Decode.txHash
        }


sendRawTx : HttpProvider -> String -> Task Http.Error TxHash
sendRawTx ethNode signedTx =
    RPC.buildRequest
        { url = ethNode
        , method = "eth_sendRawTransaction"
        , params = [ Encode.string signedTx ]
        , decoder = Decode.txHash
        }


estimateGas : HttpProvider -> TxParams a -> Task Http.Error Int
estimateGas ethNode txParams =
    RPC.buildRequest
        { url = ethNode
        , method = "eth_estimateGas"
        , params = [ Encode.callParams txParams ]
        , decoder = Decode.hexInt
        }


getBlock : HttpProvider -> Int -> Task Http.Error (Block TxHash)
getBlock ethNode blockNum =
    RPC.buildRequest
        { url = ethNode
        , method = "eth_getBlockByNumber"
        , params = [ Encode.hexInt blockNum, Encode.bool False ]
        , decoder = Decode.block Decode.txHash
        }


getBlockByHash : HttpProvider -> BlockHash -> Task Http.Error (Block TxHash)
getBlockByHash ethNode blockHash =
    RPC.buildRequest
        { url = ethNode
        , method = "eth_getBlockByHash"
        , params = [ Encode.blockHash blockHash, Encode.bool False ]
        , decoder = Decode.block Decode.txHash
        }


getBlockWithTxObjs : HttpProvider -> Int -> Task Http.Error (Block Tx)
getBlockWithTxObjs ethNode blockNum =
    RPC.buildRequest
        { url = ethNode
        , method = "eth_getBlockByNumber"
        , params = [ Encode.hexInt blockNum, Encode.bool True ]
        , decoder = Decode.block Decode.tx
        }


getBlockByHashWithTxObjs : HttpProvider -> BlockHash -> Task Http.Error (Block Tx)
getBlockByHashWithTxObjs ethNode blockHash =
    RPC.buildRequest
        { url = ethNode
        , method = "eth_getBlockByHash"
        , params = [ Encode.blockHash blockHash, Encode.bool True ]
        , decoder = Decode.block Decode.tx
        }


getTransactionByBlockHashAndIndex : HttpProvider -> BlockHash -> Int -> Task Http.Error Tx
getTransactionByBlockHashAndIndex ethNode blockHash txIndex =
    RPC.buildRequest
        { url = ethNode
        , method = "eth_getTransactionByBlockHashAndIndex"
        , params = [ Encode.blockHash blockHash, Encode.hexInt txIndex ]
        , decoder = Decode.tx
        }


getTransactionByBlockNumberAndIndex : HttpProvider -> Int -> Int -> Task Http.Error Tx
getTransactionByBlockNumberAndIndex ethNode blockNumber txIndex =
    RPC.buildRequest
        { url = ethNode
        , method = "eth_getTransactionByBlockNumberAndIndex"
        , params = [ Encode.hexInt blockNumber, Encode.hexInt txIndex ]
        , decoder = Decode.tx
        }
