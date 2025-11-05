(function(){
  const gameEl = document.getElementById('game');
  const genBtn = document.getElementById('generate');
  const copyBtn = document.getElementById('copy');
  const resultEl = document.getElementById('result');

  const RULES = {
    megasena: { picks: 6, min: 1, max: 60 },
    quina: { picks: 5, min: 1, max: 80 },
    lotofacil: { picks: 15, min: 1, max: 25 }
  };

  function randInt(min, max){
    return Math.floor(Math.random() * (max - min + 1)) + min;
  }

  function generateUniqueNumbers({picks, min, max}){
    const set = new Set();
    while(set.size < picks){
      set.add(randInt(min, max));
    }
    return Array.from(set).sort((a,b) => a - b);
  }

  function render(numbers){
    resultEl.innerHTML = '';
    const frag = document.createDocumentFragment();
    numbers.forEach(n => {
      const b = document.createElement('div');
      b.className = 'badge';
      b.textContent = String(n).padStart(2, '0');
      frag.appendChild(b);
    });
    resultEl.appendChild(frag);
    const helper = document.createElement('div');
    helper.className = 'helper';
    helper.textContent = 'Números gerados em ordem crescente.';
    resultEl.appendChild(helper);
  }

  function currentRule(){
    return RULES[gameEl.value] || RULES.megasena;
  }

  function onGenerate(){
    const nums = generateUniqueNumbers(currentRule());
    render(nums);
    copyBtn.disabled = false;
    copyBtn.dataset.clipboard = nums.join(', ');
  }

  async function onCopy(){
    const text = copyBtn.dataset.clipboard || '';
    try{
      await navigator.clipboard.writeText(text);
      const old = copyBtn.textContent;
      copyBtn.textContent = 'Copiado!';
      setTimeout(()=> copyBtn.textContent = old, 1200);
    }catch(e){
      alert('Não foi possível copiar automaticamente. Copie manualmente: ' + text);
    }
  }

  genBtn.addEventListener('click', onGenerate);
  copyBtn.addEventListener('click', onCopy);
})();
