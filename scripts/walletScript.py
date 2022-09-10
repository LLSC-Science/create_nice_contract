from ethereum.utils import *
import bitcoin
import os
from web3 import Web3, HTTPProvider


def generateWallet(choice, text):
  # choice = 'end'  # 传参，前缀/后缀
  # text = '11'  # 传参，匹配的内容

  while True:
      if (choice == 'all'):
          index = text.index('/')
          text_start = text[0:index]
          text_end = text[index + 1:len(text)]
      key = os.urandom(32)
      # 私钥
      private_key = '0x' + encode_hex(key)
      # 钱包地址
      address = Web3.toChecksumAddress('0x' + encode_hex(privtoaddr(key)))
      nonce = 0
      # 合约地址
      contractAddress = Web3.toHex(sha3(rlp.encode([normalize_address(address), nonce]))[12:])
      if ((contractAddress[-(len(text)):]).lower() == text and choice == 'end') or (
              (contractAddress[2:2 + len(text)]).lower() == text and choice == 'start') or (
              choice == 'all' and (contractAddress[-(len(text_end)):]).lower() == text_end and (
              contractAddress[2:2 + len(text_start)]).lower() == text_start):
          print('私钥' + str(private_key))
          print('账号地址' + str(address))
          print('生成的合约地址' + str(contractAddress))
          # return private_key, address, contractAddress
