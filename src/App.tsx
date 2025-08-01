import { useState } from "react";
import reactLogo from "./assets/react.svg";
import viteLogo from "/vite.svg";
import "./App.css";

// Added a new component named Counter.js
const Counter = () => {
  const [count, setCount] = useState(0);

  const incrementByTwo = () => {
    setCount(count + 2);
  };

  return (
    <>
      <div>
        <a href="https://vite.dev" target="_blank">
          <img src={viteLogo} className="logo" alt="Vite logo" />
        </a>
        <a href="https://react.dev" target="_blank">
          <img src={reactLogo} className="logo react" alt="React logo" />
        </a>
      </div>
      <h1>Vite + React</h1>
      <div className="card">
        <button onClick={incrementByTwo}>count is {count}</button>
        <p>
          Edit <code>src/components/Counter.js</code> and save to test HMR
        </p>
      </div>
      <p className="read-the-docs">
        Click on the Vite and React logos to learn more
      </p>
    </>
  );
};

// Updated App.tsx with Counter component
function App() {
  return <Counter />;
}

export default App;
