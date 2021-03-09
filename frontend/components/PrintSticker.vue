<template>
  <div>
    <div v-show="false">
      <table :id="`qr-sticker-${padQueue}`">
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
            v-on:click="print"
            class="inline-flex items-center px-4 py-2 border border-transparent shadow-sm text-sm font-medium rounded-md
            text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
      <!-- Heroicon name: printer -->
      <svg class="-ml-1 mr-2 h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24"
           stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
              d="M17 17h2a2 2 0 002-2v-4a2 2 0 00-2-2H5a2 2 0 00-2 2v4a2 2 0 002 2h2m2 4h6a2 2 0 002-2v-4a2 2 0 00-2-2H9a2 2 0 00-2 2v4a2 2 0 002 2zm8-12V5a2 2 0 00-2-2H9a2 2 0 00-2 2v4h10z"/>
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
  },
  methods: {
    async print() {
      printJS({printable: `qr-sticker-${this.padQueue}`, type: 'html', scanStyles: false})
    }
  }
}
</script>

