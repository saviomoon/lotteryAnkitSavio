import logo from './logo.svg';
import './App.css';

function App() {
  return (
    <div className="App">
      
      <h1 className="text-xl-center">LOTTERY DAPP</h1>

      <div className="input-group flex-nowrap">
    <div className="input-group-prepend">
    <span className="input-group-text" id="addon-wrapping">Enter Account ID</span>
    </div>
    <input type="text" className="form-control" placeholder="ID" aria-label="ID" aria-describedby="addon-wrapping">
      </input>  </div>
    
    <div>
    <label for="start">Select date:</label>
    
    <input type="date" id="start" name="trip-start"
    value="2020-12-11"
    min="2020-01-01" max="2021-12-31"> </input></div>

<button type="button" className="btn btn-primary">Register User</button>

<div>
<label for="Lottery_number">Slecet a Lottery Number(0-10):</label>

<input type="number" id="Lottery_number" name="Lottery_number" min="1" max="10"> </input>
</div>

<label> OR </label>
    <input type ="button" id="randomnumber" value="GET RANDOM NUMBER"> 
    <label id = "random"></label></input>

    <div className="input-group flex-nowrap">
        <div className="input-group-prepend">
        <span className="input-group-text" id="addon-wrapping">Enter BET</span>
        </div>

        <input type="number" className="form-control" placeholder="$$$" aria-label="BET" aria-describedby="addon-wrapping">
        </input>

        <button type="button" className="btn btn-primary">Transact</button>
        </div>

    </div>
  );
}

export default App;