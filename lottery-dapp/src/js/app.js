App = {
  web3Provider: null,
  contracts: {},

  init: async function() {
    return await App.initWeb3();
  },

  initWeb3: async function() {
    if (window.ethereum) {
      App.web3Provider = window.ethereum;
      try {
        // Request account access
        await window.ethereum.enable();
      } catch (error) {
        // User denied account access...
        console.error("User denied account access")
      }
    }
    // Legacy dapp browsers...
    else if (window.web3) {
      App.web3Provider = window.web3.currentProvider;
    }
    // If no injected web3 instance is detected, fall back to Ganache
    else {
      App.web3Provider = new Web3.providers.HttpProvider('http://localhost:7545');
    }
    web3 = new Web3(App.web3Provider);

    return App.initContract();
  },

  initContract: function() {
    $.getJSON('lottery.json', function(data) {
      // Get the necessary contract artifact file and instantiate it with @truffle/contract
      var LotteryArtifact = data;
      App.contracts.Lottery = TruffleContract(LotteryArtifact);
    
      // Set the provider for our contract
      App.contracts.Lottery.setProvider(App.web3Provider);
    
      // Use our contract to retrieve and mark the adopted pets
      // return App.markAdopted();
    });

    App.bindRegister();
    App.bindAddToken();
    App.bindSubmitLottery();
    App.bindAdmin();
  },

  bindRegister: function() {
    $(document).on('click', '.btn-register', App.handleRegister);
  },

  handleRegister: function(event) {
    event.preventDefault();

    var lotteryInstance;

    web3.eth.getAccounts(function(error, accounts) {
      if (error) {
        console.log(error);
      }
    
      var account = accounts[0];
    
      App.contracts.Lottery.deployed().then(function(instance) {
        lotteryInstance = instance;
    
        // Execute adopt as a transaction by sending account
        return lotteryInstance.registerUser({from: account});
      }).then(function(result) {
        var div = document.getElementById('registerLabel');
        div.innerHTML="Successfully Registered!"
      }).catch(function(err) {
        var div = document.getElementById('registerLabel');
        div.innerHTML="Error! User already Registered!"      });
    });
  },

  bindAddToken: function() {
    $(document).on('click', '.btn-addToken', App.handleAddToken);
  },

  handleAddToken: function(event) {
    event.preventDefault();

    var lotteryInstance;

    web3.eth.getAccounts(function(error, accounts) {
      if (error) {
        console.log(error);
      }
    
      var account = accounts[0];
    
      App.contracts.Lottery.deployed().then(function(instance) {
        lotteryInstance = instance;
    
        // Execute adopt as a transaction by sending account
        return lotteryInstance.addTokens({from: account});
        
      }).then(function(value){
        var div = document.getElementById('addToken');
        div.innerHTML="Token added to user successfully";
      }).catch(function(err) {
        var div = document.getElementById('addToken');
        div.innerHTML="Error! Token not added!"      });
    });
  },

  bindSubmitLottery: function() {
    $(document).on('click', '.btn-submitLottery', App.handleSubmitLottery);
  },
  handleSubmitLottery: function(event) {
    event.preventDefault();

    var lotteryInstance;

    web3.eth.getAccounts(function(error, accounts) {
      if (error) {
        console.log(error);
      }
    
      var account = accounts[0];
    
      App.contracts.Lottery.deployed().then(function(instance) {
        lotteryInstance = instance;
    
        // Execute adopt as a transaction by sending account
        return lotteryInstance.registerLotteryNumbers(document.getElementById("day").value,document.getElementById("month").value,document.getElementById("year").value,
                            document.getElementById("first").value,document.getElementById("second").value,document.getElementById("third").value,{from: account});
        
      }).then(function(value){
        var div = document.getElementById('submitLabel');
        div.innerHTML="lottery taken by user successfully";
      }).catch(function(err) {
        var div = document.getElementById('submitLabel');
        div.innerHTML="Error! Lottery generation not successful!"      });
    });
  },

  bindAdmin: function() {
    $(document).on('click', '.btn-admin', App.handleAdmin);
  },
  handleAdmin: function(event) {
    event.preventDefault();

    var lotteryInstance;

    web3.eth.getAccounts(function(error, accounts) {
      if (error) {
        console.log(error);
      }
    
      var account = accounts[0];
    
      App.contracts.Lottery.deployed().then(function(instance) {
        lotteryInstance = instance;
    
        // Execute adopt as a transaction by sending account
        return lotteryInstance.getWinningLotteryNumbers({from: account});
        
      }).then(function(value){
        var div = document.getElementById('adminLabel');
        div.innerHTML="successful";
      }).catch(function(err) {
        var div = document.getElementById('adminLabel');
        div.innerHTML="Error! Not admin!"      });
    });
  },
};

$(function() {
  $(window).load(function() {
    App.init();
  });
});
