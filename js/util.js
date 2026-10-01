/* slider helpers */
function updateSlider(slider) {
  const min = parseFloat(slider.min || 0);
  const max = parseFloat(slider.max || 100);
  const step = parseFloat(slider.step || 1);

  // Get the raw value and adjust it to the nearest valid step
  const rawValue = parseFloat(slider.value);
  const steppedValue = Math.round((rawValue - min) / step) * step + min;

  // Ensure the value is within min/max bounds and applies the step
  const value = Math.max(min, Math.min(max, steppedValue));

  // Update the actual slider value to the stepped value
  if (value !== rawValue) {
    slider.value = value;
  }

  const percent = (max === min) ? 0 : ((value - min) / (max - min)) * 100;
  slider.style.setProperty('--slider-value', `${percent}%`);
}

globalThis.initSlider = function (slider) {
  updateSlider(slider);
  slider.addEventListener('input', function (event) {
   updateSlider(event.target)
  });
}

globalThis.deinitSlider = function (slider) {
  slider.removEventListener('input', function (event) {
    updateSlider(event.target)
  });
}

globalThis.toastMsg = function (category, title, description, label) {
    return {
      detail: {
        config: {
          category: category,
          title: title,
          description: description,
          cancel: {
            label: label
          }
        }
      }
    };
}


/* copy button for code samples */
globalThis.copyButton = function (button) {
    const code = button.parentElement.querySelector('pre code');
    if (!code) return;
    navigator.clipboard.writeText(code.textContent || '').then(() => {
      button.classList.add('copied');
      setTimeout(() => { button.classList.remove('copied') }, 2000);
    }).catch(err => {
      console.error('Failed to copy text: ', err);
    });
}

/* scroll to the element named by a URI fragment ("#id") */
globalThis.scrollToFragment = function (fragment) {
  const frag = fragment.slice(1);
  if (frag) {
    const element = document.getElementById(frag);
    if (element) element.scrollIntoView();
  }
}

/* basecoat events: 'sidebar', 'theme' */
globalThis.dispatchBasecoat = function (name) {
  document.dispatchEvent(new CustomEvent('basecoat:' + name));
}

globalThis.showToast = function (category, title, description, label) {
  const msg = toastMsg(category, title, description, label);
  document.dispatchEvent(new CustomEvent('basecoat:toast', msg));
}

/* swap the theme-* class on <html> */
globalThis.changeTheme = function (theme) {
  document.documentElement.classList.forEach(c => {
    if (c.startsWith('theme-')) {
      document.documentElement.classList.remove(c);
    }
  });
  document.documentElement.classList.add('theme-' + theme);
}
