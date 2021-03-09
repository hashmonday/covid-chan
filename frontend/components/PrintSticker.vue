<template>
  <div>
    <div v-show="false">
      <table id="qr-sticker">
        <tr>
          <td>
            <vue-qr :text="refNum" :size="63" :margin="0"></vue-qr>
          </td>
          <td>
            <svg width="138" height="63">
              <text x="2" y="12" font-size="smaller" font-weight="bold">{{ refNum }}</text>
              <text x="2" y="28" font-size="x-small">{{ fullName }}</text>
              <text x="2" y="62" font-size="x-small">{{ datetime }}</text>
              <rect x="94" y="42" rx="3" ry="3" width="43" height="20"
                    style="fill:rgb(0,0,0);stroke-width:2;stroke:rgb(0,0,0)"/>
              <text x="98" y="58" font-size="18" font-weight="bold" fill="white">{{ padQueue }}</text>
            </svg>
          </td>
        </tr>
      </table>
    </div>
    <button type="button"
            onclick="printJS({ printable:'qr-sticker', type: 'html',scanStyles: false})"
            class="inline-flex items-center px-4 py-2 border border-transparent shadow-sm text-sm font-medium rounded-md
            text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
      <!-- Heroicon name: solid/printer -->
      <svg class="-ml-1 mr-2 h-5 w-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
        <path fill-rule="evenodd"
              d="M5 4v3H4a2 2 0 00-2 2v3a2 2 0 002 2h1v2a2 2 0 002 2h6a2 2 0 002-2v-2h1a2 2 0 002-2V9a2 2 0 00-2-2h-1V4a2 2 0 00-2-2H7a2 2 0 00-2 2zm8 0H7v3h6V4zm0 8H7v4h6v-4z"
              clip-rule="evenodd"/>
      </svg>
      {{ btnName }}
    </button>
  </div>
</template>


<script>
import VueQr from 'vue-qr'
import printJS from 'print-js'

export default {
  name: 'PrintSticker',
  props: {
    'buttonName': String,
    'refNum': String,
    'fullName': String,
    'datetime': String,
    'queue': String,
  },
  components: {VueQr},
  computed: {
    padQueue() {
      let num = this.queue
      return num.padStart(4, '0')
    },
    btnName() {
      let name = this.buttonName
      if (name != null) {
        return name
      } else {
        return 'Print'
      }
    }
  }
}
</script>

