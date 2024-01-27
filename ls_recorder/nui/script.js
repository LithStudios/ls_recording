let settings = {};

document.addEventListener('DOMContentLoaded', function() {
  //$(".container").fadeOut(1000);
  document.querySelector(".save-button").style.opacity = '0';
  document.querySelector(".overlap-group-container").style.opacity = '0';
  const checkboxes = document.querySelectorAll('.checkbox-input');
  checkboxes.forEach(function(checkbox) {
    checkbox.addEventListener('click', function() {
      const checkboxID = this.id;
      const isChecked = this.checked;
      updateSettings(checkboxID, isChecked);
      storeSettings(settings);
    });
  });

  const storedSettings = localStorage.getItem('ls_rdm:recordingSettings');
  if (storedSettings) {
    settings = JSON.parse(storedSettings);
    applySettingsToCheckboxes(settings);
    sendSettingsToClient(settings)
  } else {
    initializeSettings();
    storeSettings(settings);
    sendSettingsToClient(settings)
  }

  const saveButton = document.querySelector('.save-button');

  saveButton.addEventListener('click', function() {
    document.querySelector(".overlap-group").style.opacity = '0';
    document.querySelector(".save-button").style.opacity = '0';
    sendSettingsToClient(settings)
  })
});

function sendSettingsToClient(settings) {
  fetch(`https://${GetParentResourceName()}/retrieveSettings`, {
    method: 'POST',
    body: JSON.stringify({
      settings: settings,
    })
  })
}


function updateSettings(checkboxID, isChecked) {
  settings[checkboxID] = isChecked;
}

function initializeSettings() {
  const checkboxes = document.querySelectorAll('.checkbox-input');
  checkboxes.forEach(function(checkbox) {
    const checkboxID = checkbox.id;
    updateSettings(checkboxID, true);
  });
}

function applySettingsToCheckboxes(settings) {
  const checkboxes = document.querySelectorAll('.checkbox-input');
  checkboxes.forEach(function(checkbox) {
    const checkboxID = checkbox.id;
    checkbox.checked = settings[checkboxID] || false;
  });
}

function storeSettings(settings) {
  localStorage.setItem('ls_rdm:recordingSettings', JSON.stringify(settings));
}

$(document).ready(() => {
  window.addEventListener('message', (event) => {
    if (event.data.event === 'initialize') {
      initializeSettings();
      storeSettings(settings);
    }
    if (event.data.event === 'openSettings') {
      document.querySelector(".overlap-group").style.opacity = '1';
      document.querySelector(".save-button").style.opacity = '1';
    }
    if (event.data.event === 'enablePrompt') {
      const overlapGroupContainer = document.querySelector(".overlap-group-container");
      const paragraph = overlapGroupContainer.querySelector(".paragraph");

      // Set the opacity of the overlap-group-container
      overlapGroupContainer.style.opacity = '1';

      // Update the content based on event.data.startKeybind and event.data.endKeybind
      const startKeybind = event.data.startKeybind || 'defaultStartKeybind';
      const endKeybind = event.data.endKeybind || 'defaultEndKeybind';

      const content = `
    <div class="div-wrapper">
      <div class="div-element">Save recording?</div>
    </div>
    <p class="paragraph">Recording will auto-delete in 5 seconds. Press <strong>'${startKeybind}'</strong> to save recording. Press <strong>'${endKeybind}'</strong> to stop the recording.</p>
  `;

      // Set the innerHTML of the overlap-group-container
      overlapGroupContainer.innerHTML = content;
    }

    if (event.data.event === 'disablePrompt') {
      document.querySelector(".overlap-group-container").style.opacity = '0';
    }
  });
});

function debounce(func, wait, immediate) {
  let timeout;
  return function () {
    const context = this,
        args = arguments;
    const later = function () {
      timeout = null;
      if (!immediate) func.apply(context, args);
    };
    const callNow = immediate && !timeout;
    clearTimeout(timeout);
    timeout = setTimeout(later, wait);
    if (callNow) func.apply(context, args);
  };
}

// Apply the debounce function to the hover event
document.querySelectorAll('.checkbox-tile').forEach((checkbox) => {
  checkbox.addEventListener(
      'mouseover',
      debounce(function (event) {
        // Your code to show the additional info here
      }, 100) // Adjust the wait time as needed
  );
});
