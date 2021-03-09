<template>
  <div class="px-4 py-5 sm:p-6">
    <div class="relative rounded-md shadow-sm">
      <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
        <!-- Heroicon name: solid/identification -->
        <svg class="h-5 w-5 text-gray-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20"
             fill="currentColor">
          <path fill-rule="evenodd"
                d="M10 2a1 1 0 00-1 1v1a1 1 0 002 0V3a1 1 0 00-1-1zM4 4h3a3 3 0 006 0h3a2 2 0 012 2v9a2 2 0 01-2 2H4a2 2 0 01-2-2V6a2 2 0 012-2zm2.5 7a1.5 1.5 0 100-3 1.5 1.5 0 000 3zm2.45 4a2.5 2.5 0 10-4.9 0h4.9zM12 9a1 1 0 100 2h3a1 1 0 100-2h-3zm-1 4a1 1 0 011-1h2a1 1 0 110 2h-2a1 1 0 01-1-1z"
                clip-rule="evenodd"/>
        </svg>
      </div>
      <input
        v-model="refNum" type="text"
        id="search"
        ref="search"
        class="focus:ring-indigo-500 focus:border-indigo-500 block w-full pl-10 sm:text-sm border-gray-300 rounded-md"
        v-on:keyup.enter="getPerson()"
        maxlength="13"
        placeholder="กรุณากรอกหมายเลขประจำตัว แล้วกดปุ่ม Enter เพื่อค้นหารายการ"
        autocomplete="off"
        :class="createMode || editMode ? 'bg-gray-100' : ''"
        :disabled="createMode || editMode"
      />
    </div>

    <div v-show="blankMode">
      <div class="pt-6 space-y-6">
        <div class="bg-white shadow px-4 py-5 sm:rounded-lg sm:p-6">
          <div class="md:grid md:grid-cols-3 md:gap-6">
            <div class="md:col-span-1">
              <h3 class="text-lg font-medium leading-6 text-gray-900">{{ headerName }}</h3>
              <p class="mt-1 text-sm text-gray-500">
                ข้อมูลผู้เข้ารับบริการตรวจโควิด 19
              </p>
            </div>
            <div class="mt-5 md:mt-0 md:col-span-2">
              <div class="grid grid-cols-6 gap-6">
                <div class="col-span-6 sm:col-span-2">
                  <label for="title" class="block text-sm font-medium text-gray-700">คำนำหน้าชื่อ</label>
                  <select v-model="title"
                          id="title"
                          autocomplete="off"
                          :class="viewMode ? 'bg-gray-100' : ''"
                          class="mt-1 block w-full py-2 px-3 border border-gray-300 bg-white rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
                          :disabled="viewMode">
                    <option v-for="title in titles" :key="title.id" :value="title.id">{{ title.title }}</option>
                  </select>
                </div>

                <div class="col-span-6 sm:col-span-2">
                  <label for="first_name" class="block text-sm font-medium text-gray-700">ชื่อ</label>
                  <input type="text"
                         v-model="firstName"
                         id="first_name"
                         autocomplete="off"
                         :class="viewMode ? 'bg-gray-100' : ''"
                         class="mt-1 focus:ring-indigo-500 focus:border-indigo-500 block w-full shadow-sm sm:text-sm border-gray-300 rounded-md"
                         :disabled="viewMode">
                </div>

                <div class="col-span-6 sm:col-span-2">
                  <label for="last_name" class="block text-sm font-medium text-gray-700">นามสกุล</label>
                  <input type="text"
                         v-model="lastName"
                         id="last_name"
                         autocomplete="off"
                         :class="viewMode ? 'bg-gray-100' : ''"
                         class="mt-1 focus:ring-indigo-500 focus:border-indigo-500 block w-full shadow-sm sm:text-sm border-gray-300 rounded-md"
                         :disabled="viewMode">
                </div>

                <div class="col-span-6 sm:col-span-2">
                  <label for="location" class="block text-sm font-medium text-gray-700">สถานที่ตรวจโควิด</label>
                  <input type="text"
                         v-model="location"
                         id="location"
                         autocomplete="off"
                         class="mt-1 bg-gray-100 focus:ring-indigo-500 focus:border-indigo-500 block w-full shadow-sm sm:text-sm border-gray-300 rounded-md"
                         disabled>
                </div>
              </div>
            </div>
          </div>
        </div>

        <div class="flex justify-end">
          <button type="button"
                  v-on:click="cancel"
                  class="bg-white py-2 px-4 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
            ยกเลิก
          </button>
          <div v-show="createMode">
            <button type="button"
                    v-on:click="createPerson"
                    class="ml-3 inline-flex justify-center py-2 px-4 border border-transparent shadow-sm text-sm font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
              สร้าง
            </button>
          </div>
          <div v-show="viewMode">
            <button type="button"
                    v-on:click="editPerson"
                    class="ml-3 inline-flex justify-center py-2 px-4 border border-transparent shadow-sm text-sm font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
              แก้ไข
            </button>
          </div>
          <div v-show="editMode">
            <button type="button"
                    v-on:click="editPerson"
                    class="ml-3 inline-flex justify-center py-2 px-4 border border-transparent shadow-sm text-sm font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
              บันทึก
            </button>
          </div>
          <div v-show="viewMode">
            <PrintSticker class="ml-3" button-name="พิมพ์สติ๊กเกอร์" :ref-num="refNum" :full-name="fullName"
                          :datetime="$dayjs().format('DD/MM/YYYY hh:mm')" queue="62"/>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      mode: '',
      id: '',
      refNum: '',
      titles: [],
      title: '',
      firstName: '',
      lastName: '',
      location: '',
    }
  },
  async fetch() {
    await this.$strapi.find('titles').then(result => {
      this.titles = result
    }).catch(err => {
      console.log(err)
    })
    await this.$strapi.find('covid-testing-locations', {active: true}).then(result => {
      if (result.length === 1) {
        this.location = result[0].name
      } else {
        console.log("กรุณาตรวจสอบการตั้งค่า สถานที่ตรวจโควิด")
      }
    }).catch(err => {
      console.log(err)
    })
  },
  mounted() {
    this.focusInput();
  },
  computed: {
    headerName() {
      let name = ''
      switch (this.mode) {
        case 'create':
          name = 'สร้างข้อมูลส่วนบุคคล'
          break
        case 'edit':
          name = 'แก้ไขข้อมูลส่วนบุคคล'
          break
        default:
          name = 'ข้อมูลส่วนบุคคล'
      }
      return name
    },
    viewMode() {
      return this.mode === 'view'
    },
    createMode() {
      return this.mode === 'create'
    },
    editMode() {
      return this.mode === 'edit'
    },
    blankMode() {
      return this.mode !== ''
    },
    fullName() {
      return `${this.title.title} ${this.firstName} ${this.lastName}`
    }
  },
  methods: {
    getPerson: async function () {
      let num = this.refNum
      if (num.length === 13 && /[0-9]{13}/.test(num)) {
        await this.$strapi.find('persons', {reference_number: num}).then(result => {
          if (result.length === 1) {
            this.mode = 'view'
            this.id = result[0]['id']
            this.title = result[0]['title']['id']
            this.firstName = result[0]['first_name']
            this.lastName = result[0]['last_name']
          } else if (result.length === 0) {
            this.mode = 'create'
            this.id = ''
            this.title = ''
            this.firstName = ''
            this.lastName = ''
          }
        }).catch(err => {
          console.log(err)
        })
      }
    },
    createPerson: async function () {
      let num = this.refNum
      if (num.length === 13 && /[0-9]{13}/.test(num)) {
        await this.$strapi.find('persons', {reference_number: num}).then(async result => {
          if (result.length === 0) {
            await this.$strapi.create('persons', {
              reference_number: num,
              title: this.title,
              first_name: this.firstName,
              last_name: this.lastName
            }).then(result => {
              this.mode = 'view'
              this.id = result[0]['id']
              this.refNum = result[0]['reference_number']
              this.title = result[0]['title']['id']
              this.firstName = result[0]['first_name']
              this.lastName = result[0]['last_name']
            }).catch(err => {
              console.log(err)
            })
          } else if (result.length === 1) {
            this.mode = 'view'
            this.id = result[0]['id']
            this.title = result[0]['title']['id']
            this.firstName = result[0]['first_name']
            this.lastName = result[0]['last_name']
          }
        }).catch(err => {
          console.log(err)
        })
      }
    },
    editPerson: async function () {
      this.mode = 'edit'
    },
    focusInput() {
      this.$refs.search.removeAttribute('disabled')
      this.$refs.search.focus()
    },
    cancel() {
      if (this.editMode) {
        this.mode = 'view'
      } else {
        this.mode = ''
        this.id = ''
        this.refNum = ''
        this.title = ''
        this.firstName = ''
        this.lastName = ''
        this.focusInput();
      }
    }
  }
}
</script>
