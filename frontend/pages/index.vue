<template>
  <div class="px-4 py-5 sm:p-6">
    <!-- SEARCH -->
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
        :class="viewMode || createMode || editMode ? 'bg-gray-100' : ''"
        :disabled="viewMode || createMode || editMode"
      />
    </div>

    <!--SUCCESS MESSAGE-->
    <div class="mt-6 rounded-md bg-green-50 p-4" v-show="successMessages !== ''">
      <div class="flex">
        <div class="flex-shrink-0">
          <!-- Heroicon name: solid/check-circle -->
          <svg class="h-5 w-5 text-green-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor"
               aria-hidden="true">
            <path fill-rule="evenodd"
                  d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z"
                  clip-rule="evenodd"/>
          </svg>
        </div>
        <div class="ml-3">
          <p class="text-sm font-medium text-green-800">
            {{ successMessages }}
          </p>
        </div>
        <div class="ml-auto pl-3">
          <div class="-mx-1.5 -my-1.5">
            <button
              v-on:click="closeMessage"
              class="inline-flex bg-green-50 rounded-md p-1.5 text-green-500 hover:bg-green-100 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-offset-green-50 focus:ring-green-600">
              <span class="sr-only">Dismiss</span>
              <!-- Heroicon name: solid/x -->
              <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor"
                   aria-hidden="true">
                <path fill-rule="evenodd"
                      d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z"
                      clip-rule="evenodd"/>
              </svg>
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- ERROR MESSAGE -->
    <div class="mt-6 rounded-md bg-red-50 p-4" v-show="haveErrors">
      <div class="flex">
        <div class="flex-shrink-0">
          <!-- Heroicon name: solid/x-circle -->
          <svg class="h-5 w-5 text-red-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor"
               aria-hidden="true">
            <path fill-rule="evenodd"
                  d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z"
                  clip-rule="evenodd"/>
          </svg>
        </div>
        <div class="ml-3">
          <h3 class="text-sm font-medium text-red-800">
            เกิดข้อผิดพลาด
          </h3>
          <div class="mt-2 text-sm text-red-700">
            <ul class="list-disc pl-5 space-y-1">
              <li v-for="(errorMessage, index) in errorMessages" :key="index">
                {{ errorMessage }}
              </li>
            </ul>
          </div>
        </div>
        <div class="ml-auto pl-3">
          <div class="-mx-1.5 -my-1.5">
            <button
              v-on:click="closeMessage"
              class="inline-flex bg-red-50 rounded-md p-1.5 text-red-500 hover:bg-red-100 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-offset-red-50 focus:ring-red-600">
              <span class="sr-only">Dismiss</span>
              <!-- Heroicon name: solid/x -->
              <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor"
                   aria-hidden="true">
                <path fill-rule="evenodd"
                      d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z"
                      clip-rule="evenodd"/>
              </svg>
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- CONTENT -->
    <div v-show="blankMode">
      <div class="mt-6 space-y-6">
        <!-- PERSON INFO -->
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
                  <label for="date_of_birth" class="block text-sm font-medium text-gray-700">วันเดือนปีเกิด (ค.ศ.)</label>
                  <input type="date"
                         v-model="dateOfBirth"
                         id="date_of_birth"
                         ref="dob"
                         autocomplete="off"
                         :class="viewMode ? 'bg-gray-100' : ''"
                         class="mt-1 focus:ring-indigo-500 focus:border-indigo-500 block w-full shadow-sm sm:text-sm border-gray-300 rounded-md"
                         :disabled="viewMode">
                </div>

                <div class="col-span-6 sm:col-span-1">
                  <label for="nationality" class="block text-sm font-medium text-gray-700">สัญชาติ</label>
                  <select v-model="nationality"
                          id="nationality"
                          ref="nationality"
                          autocomplete="off"
                          :class="viewMode ? 'bg-gray-100' : ''"
                          class="mt-1 block w-full py-2 px-3 border border-gray-300 bg-white rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
                          :disabled="viewMode">
                    <option v-for="nationality in nationalities" :key="nationality.id" :value="nationality.id">
                      {{ nationality.name }}
                    </option>
                  </select>
                </div>

                <div class="col-span-6 sm:col-span-2">
                  <label for="employerName" class="block text-sm font-medium text-gray-700">
                    นายจ้าง
                  </label>
                  <div class="mt-1 relative">
                    <input type="text"
                           v-on:keyup="findEmployer()"
                           v-model="employerName"
                           ref="employerName"
                           id="employerName"
                           autocomplete="off"
                           :class="viewMode ? 'bg-gray-100' : ''"
                           class="mt-1 focus:ring-indigo-500 focus:border-indigo-500 block w-full shadow-sm sm:text-sm border-gray-300 rounded-md"
                           :disabled="viewMode">

                    <transition
                      enter-active-class=""
                      enter-from-class=""
                      enter-to-class=""
                      leave-active-class="transition ease-in duration-100"
                      leave-from-class="opacity-100"
                      leave-to-class="opacity-0"
                    >
                    <div class="absolute mt-1 w-full rounded-md bg-white shadow-lg" v-show="employers.length > 0">
                      <ul tabindex="-1" role="listbox" aria-labelledby="listbox-label" aria-activedescendant="listbox-option-0" class="max-h-60 rounded-md py-1 text-base ring-1 ring-black ring-opacity-5 overflow-auto focus:outline-none sm:text-sm">
                        <!--
                          Select option, manage highlight styles based on mouseenter/mouseleave and keyboard navigation.

                          Highlighted: "text-white bg-indigo-600", Not Highlighted: "text-gray-900"
                        -->
                        <li
                            v-for="(employer,index) in employers"
                            :key="index"
                            :id="`listbox-option-${index}`"
                            v-on:click="employerName = employer.name; employers = []"
                            role="option"
                            class="text-gray-900 cursor-default select-none relative py-2 pl-3 pr-9">
                          <!-- Selected: "font-semibold", Not Selected: "font-normal" -->
                          <span class="font-normal block truncate">
                            {{employer.name}}
                          </span>
                        </li>
                      </ul>
                    </div>
                    </transition>
                  </div>
                </div>

              </div>
            </div>
          </div>
        </div>

        <!-- SERVICE LIST -->
        <div class=" mt-6 bg-white shadow overflow-hidden sm:rounded-md" v-show="services.length > 0">
          <ul class="divide-y divide-gray-200">
            <li v-for="service in services" :key="service.id">
              <div class="block hover:bg-gray-50">
                <div class="px-4 py-4 sm:px-6">
                  <div class="flex items-center justify-between">
                    <p class="text-lg font-medium text-grey-900 truncate">
                      หมายเลขคิวที่ {{ service.queue }}
                    </p>
                    <div class="ml-2 flex-shrink-0 flex">

                      <!-- REMOVE SERVICE -->
                      <button type="button"
                              v-on:click="serviceId = service['id']; closeMessage()"
                              class="ml-3 inline-flex justify-center py-2 px-4 border border-transparent shadow-sm text-sm font-medium rounded-md text-white bg-red-500 hover:bg-red-600 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-400">
                        <!-- Heroicon name: trash -->
                        <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24"
                             stroke="currentColor">
                          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/>
                        </svg>
                      </button>

                      <!-- PRINT STICKER -->
                      <div v-show="viewMode">
                        <PrintSticker class="ml-3" button-name="พิมพ์สติ๊กเกอร์" :ref-num="refNum" :full-name="fullName"
                                      :datetime="String(service['check_in'])" :queue="String(service.queue)"/>
                      </div>

                    </div>
                  </div>
                  <div class="mt-2 sm:flex sm:justify-between">
                    <div class="sm:flex">
                      <p class="flex items-center text-sm text-gray-500">
                        <!-- Heroicon name: solid/location-marker -->
                        <svg class="flex-shrink-0 mr-1.5 h-5 w-5 text-gray-400" xmlns="http://www.w3.org/2000/svg"
                             viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                          <path fill-rule="evenodd"
                                d="M5.05 4.05a7 7 0 119.9 9.9L10 18.9l-4.95-4.95a7 7 0 010-9.9zM10 11a2 2 0 100-4 2 2 0 000 4z"
                                clip-rule="evenodd"/>
                        </svg>
                        {{ service.location['location_name'] }}
                      </p>
                      <p class="mt-2 flex items-center text-sm text-gray-500 sm:mt-0 sm:ml-6">
                        <!-- Heroicon name: solid/calendar -->
                        <svg class="flex-shrink-0 mr-1.5 h-5 w-5 text-gray-400" xmlns="http://www.w3.org/2000/svg"
                             viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                          <path fill-rule="evenodd"
                                d="M6 2a1 1 0 00-1 1v1H4a2 2 0 00-2 2v10a2 2 0 002 2h12a2 2 0 002-2V6a2 2 0 00-2-2h-1V3a1 1 0 10-2 0v1H7V3a1 1 0 00-1-1zm0 5a1 1 0 000 2h8a1 1 0 100-2H6z"
                                clip-rule="evenodd"/>
                        </svg>
                        <time :datetime="service['appointment_date']">
                          {{ $dayjs(service['appointment_date'], 'YYYY-MM-DD').format('DD/MM/BB') }}
                        </time>
                      </p>
                    </div>
                    <div class="mt-2 flex items-center text-sm text-gray-500 sm:mt-0"
                         v-show="services['appointment_date'] !== ''">
                      <!-- Heroicon name: solid/calendar -->
                      <svg class="flex-shrink-0 mr-1.5 h-5 w-5 text-gray-400" xmlns="http://www.w3.org/2000/svg"
                           viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                        <path fill-rule="evenodd"
                              d="M6 2a1 1 0 00-1 1v1H4a2 2 0 00-2 2v10a2 2 0 002 2h12a2 2 0 002-2V6a2 2 0 00-2-2h-1V3a1 1 0 10-2 0v1H7V3a1 1 0 00-1-1zm0 5a1 1 0 000 2h8a1 1 0 100-2H6z"
                              clip-rule="evenodd"/>
                      </svg>
                      <p>
                        เข้ารับบริการเมื่อ
                        <time datetime="2020-01-07">
                          {{ $dayjs(service['check_in'], 'YYYY-MM-DD HH:mm').format('DD/MM/BB HH:mm') }}
                        </time>
                      </p>
                    </div>
                  </div>
                </div>
              </div>
            </li>
          </ul>
        </div>

        <!-- BUTTONS -->
        <div class="flex justify-end">
          <button type="button"
                  v-on:click="cancel"
                  class="bg-white py-2 px-4 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
            {{ viewMode ? 'ย้อนกลับไปหน้าแรก' : 'ยกเลิก' }}
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
              แก้ไขข้อมูลบุคคล
            </button>
          </div>
          <div v-show="viewMode && services.length === 0">
            <button type="button"
                    v-on:click="addService"
                    class="ml-3 inline-flex justify-center py-2 px-4 border border-transparent shadow-sm text-sm font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
              สร้างรายการเข้ารับบริการใหม่
            </button>
          </div>
          <div v-show="editMode">
            <button type="button"
                    v-on:click="updatePerson"
                    class="ml-3 inline-flex justify-center py-2 px-4 border border-transparent shadow-sm text-sm font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
              บันทึก
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- SERVICE MODAL -->
    <div class="fixed z-10 inset-0 overflow-y-auto" v-show="createServiceMode">
      <div class="flex items-end justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0">

        <transition
          enter-active-class="ease-out duration-300"
          enter-from-class="opacity-0"
          enter-to-class="opacity-100"
          leave-active-class="ease-in duration-200"
          leave-from-class="opacity-100"
          leave-to-class="opacity-0"
        >
          <div class="fixed inset-0 transition-opacity" aria-hidden="true">
            <div class="absolute inset-0 bg-gray-500 opacity-75"></div>
          </div>
        </transition>
        <!-- This element is to trick the browser into centering the modal contents. -->
        <span class="hidden sm:inline-block sm:align-middle sm:h-screen" aria-hidden="true">&#8203;</span>

        <transition
          enter-active-class="ease-out duration-300"
          enter-from-class="opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"
          enter-to-class="opacity-100 translate-y-0 sm:scale-100"
          leave-active-class="ease-in duration-200"
          leave-from-class="opacity-100 translate-y-0 sm:scale-100"
          leave-to-class="opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"
        >
          <div
            class="inline-block align-bottom bg-white rounded-lg px-4 pt-5 pb-4 text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:align-middle sm:max-w-lg sm:w-full sm:p-6"
            role="dialog" aria-modal="true" aria-labelledby="modal-headline">
            <div class="sm:flex sm:items-start">
              <div
                class="mx-auto flex-shrink-0 flex items-center justify-center h-12 w-12 rounded-full bg-indigo-100 sm:mx-0 sm:h-10 sm:w-10">
                <!-- Heroicon name: outline/beaker -->
                <svg class="h-6 w-6 text-indigo-600" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24"
                     stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                        d="M19.428 15.428a2 2 0 00-1.022-.547l-2.387-.477a6 6 0 00-3.86.517l-.318.158a6 6 0 01-3.86.517L6.05 15.21a2 2 0 00-1.806.547M8 4h8l-1 1v5.172a2 2 0 00.586 1.414l5 5c1.26 1.26.367 3.414-1.415 3.414H4.828c-1.782 0-2.674-2.154-1.414-3.414l5-5A2 2 0 009 10.172V5L8 4z"/>
                </svg>
              </div>
              <div class="mt-3 text-center sm:mt-0 sm:ml-4 sm:text-left">
                <h3 class="text-lg leading-6 font-medium text-gray-900" id="modal-headline3">
                  เข้ารับบริการตรวจ Covid-19
                </h3>

                <div class="mt-2">
                  <div class="grid grid-cols-6 gap-6">
                    <div class="col-span-6 sm:col-span-3">
                      <label for="location" class="block text-sm font-medium text-gray-700">สถานที่ตรวจโควิด</label>
                      <input type="text"
                             v-model="mobileCovidStation"
                             id="location"
                             autocomplete="off"
                             class="mt-1 bg-gray-100 focus:ring-indigo-500 focus:border-indigo-500 block w-full shadow-sm sm:text-sm border-gray-300 rounded-md"
                             disabled>
                    </div>
                    <div class="col-span-6 sm:col-span-3">
                      <label for="queue" class="block text-sm font-medium text-gray-700">คิวที่</label>
                      <input type="text"
                             v-on:keyup.enter="createService"
                             v-model="queue"
                             id="queue"
                             ref="queue"
                             maxlength="4"
                             autocomplete="off"
                             class="mt-1 bg-gray-100 focus:ring-indigo-500 focus:border-indigo-500 block w-full shadow-sm sm:text-sm border-gray-300 rounded-md">
                    </div>
                  </div>
                </div>
                <div class="mt-2 rounded-md bg-red-50 p-4" v-show="errorServiceModal">
                  <div class="flex">
                    <div class="flex-shrink-0">
                      <!-- Heroicon name: solid/x-circle -->
                      <svg class="h-5 w-5 text-red-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20"
                           fill="currentColor" aria-hidden="true">
                        <path fill-rule="evenodd"
                              d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z"
                              clip-rule="evenodd"/>
                      </svg>
                    </div>
                    <div class="ml-3">
                      <h3 class="text-sm font-sm text-red-800">
                        {{ errorServiceModal }}
                      </h3>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <div class="mt-5 sm:mt-4 sm:flex sm:flex-row-reverse">
              <button type="button"
                      v-on:click="createService"
                      class="w-full inline-flex justify-center rounded-md border border-transparent shadow-sm px-4 py-2 bg-indigo-600 text-base font-medium text-white hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500 sm:ml-3 sm:w-auto sm:text-sm">
                เข้ารับบริการ
              </button>
              <button type="button"
                      v-on:click="closeServiceModal"
                      class="mt-3 w-full inline-flex justify-center rounded-md border border-gray-300 shadow-sm px-4 py-2 bg-white text-base font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 sm:mt-0 sm:w-auto sm:text-sm">
                ยกเลิก
              </button>
            </div>
          </div>
        </transition>
      </div>
    </div>

    <!-- REMOVE SERVICE MODAL -->
    <div class="fixed z-10 inset-0 overflow-y-auto" v-show="serviceId">
      <div class="flex items-end justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0">

        <transition
          enter-active-class="ease-out duration-300"
          enter-from-class="opacity-0"
          enter-to-class="opacity-100"
          leave-active-class="ease-in duration-200"
          leave-from-class="opacity-100"
          leave-to-class="opacity-0"
        >
          <div class="fixed inset-0 transition-opacity" aria-hidden="true">
            <div class="absolute inset-0 bg-gray-500 opacity-75"></div>
          </div>
        </transition>

        <!-- This element is to trick the browser into centering the modal contents. -->
        <span class="hidden sm:inline-block sm:align-middle sm:h-screen" aria-hidden="true">&#8203;</span>

        <transition
          enter-active-class="ease-out duration-300"
          enter-from-class="opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"
          enter-to-class="opacity-100 translate-y-0 sm:scale-100"
          leave-active-class="ease-in duration-200"
          leave-from-class="opacity-100 translate-y-0 sm:scale-100"
          leave-to-class="opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"
        >
          <div
            class="inline-block align-bottom bg-white rounded-lg px-4 pt-5 pb-4 text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:align-middle sm:max-w-lg sm:w-full sm:p-6"
            role="dialog" aria-modal="true" aria-labelledby="modal-headline">
            <div class="sm:flex sm:items-start">
              <div
                class="mx-auto flex-shrink-0 flex items-center justify-center h-12 w-12 rounded-full bg-red-100 sm:mx-0 sm:h-10 sm:w-10">
                <!-- Heroicon name: outline/exclamation -->
                <svg class="h-6 w-6 text-red-600" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24"
                     stroke="currentColor" aria-hidden="true">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                        d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/>
                </svg>
              </div>
              <div class="mt-3 text-center sm:mt-0 sm:ml-4 sm:text-left">
                <h3 class="text-lg leading-6 font-medium text-gray-900" id="modal-headline">
                  ลบคิว
                </h3>
                <div class="mt-2">
                  <p class="text-sm text-gray-500">
                    ท่านต้องการที่จะดำเนินการลบคิวนี้ออกจากระบบหรือไม่?
                  </p>
                </div>
              </div>
            </div>
            <div class="mt-5 sm:mt-4 sm:flex sm:flex-row-reverse">
              <button type="button"
                      v-on:click="deleteService"
                      class="w-full inline-flex justify-center rounded-md border border-transparent shadow-sm px-4 py-2 bg-red-600 text-base font-medium text-white hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500 sm:ml-3 sm:w-auto sm:text-sm">
                ลบ
              </button>
              <button type="button"
                      v-on:click="serviceId=''"
                      class="mt-3 w-full inline-flex justify-center rounded-md border border-gray-300 shadow-sm px-4 py-2 bg-white text-base font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 sm:mt-0 sm:w-auto sm:text-sm">
                ยกเลิก
              </button>
            </div>
          </div>
        </transition>
      </div>
    </div>

    <!-- CONFIRM CANCEL MODAL -->
    <div class="fixed z-10 inset-0 overflow-y-auto" v-show="confirmCancelModal">
      <div class="flex items-end justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0">

        <transition
          enter-active-class="ease-out duration-300"
          enter-from-class="opacity-0"
          enter-to-class="opacity-100"
          leave-active-class="ease-in duration-200"
          leave-from-class="opacity-100"
          leave-to-class="opacity-0"
        >
          <div class="fixed inset-0 transition-opacity" aria-hidden="true">
            <div class="absolute inset-0 bg-gray-500 opacity-75"></div>
          </div>
        </transition>

        <!-- This element is to trick the browser into centering the modal contents. -->
        <span class="hidden sm:inline-block sm:align-middle sm:h-screen" aria-hidden="true">&#8203;</span>

        <transition
          enter-active-class="ease-out duration-300"
          enter-from-class="opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"
          enter-to-class="opacity-100 translate-y-0 sm:scale-100"
          leave-active-class="ease-in duration-200"
          leave-from-class="opacity-100 translate-y-0 sm:scale-100"
          leave-to-class="opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"
        >
          <div
            class="inline-block align-bottom bg-white rounded-lg px-4 pt-5 pb-4 text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:align-middle sm:max-w-lg sm:w-full sm:p-6"
            role="dialog" aria-modal="true" aria-labelledby="modal-headline">
            <div class="sm:flex sm:items-start">
              <div
                class="mx-auto flex-shrink-0 flex items-center justify-center h-12 w-12 rounded-full bg-red-100 sm:mx-0 sm:h-10 sm:w-10">
                <!-- Heroicon name: outline/exclamation -->
                <svg class="h-6 w-6 text-yellow-600" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24"
                     stroke="currentColor" aria-hidden="true">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                        d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/>
                </svg>
              </div>
              <div class="mt-3 text-center sm:mt-0 sm:ml-4 sm:text-left">
                <h3 class="text-lg leading-6 font-medium text-gray-900" id="modal-headline2">
                  แจ้งเตือน
                </h3>
                <div class="mt-2">
                  <p class="text-sm text-gray-500">
                    ท่านต้องการที่จะยกเลิกรายการที่กำลังทำอยู่หรือไม่?
                  </p>
                </div>
              </div>
            </div>
            <div class="mt-5 sm:mt-4 sm:flex sm:flex-row-reverse">
              <button type="button"
                      v-on:click="confirmCancel()"
                      class="w-full inline-flex justify-center rounded-md border border-transparent shadow-sm px-4 py-2 bg-red-600 text-base font-medium text-white hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500 sm:ml-3 sm:w-auto sm:text-sm">
                ตกลง
              </button>
              <button type="button"
                      v-on:click="confirmCancelModal=false"
                      class="mt-3 w-full inline-flex justify-center rounded-md border border-gray-300 shadow-sm px-4 py-2 bg-white text-base font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 sm:mt-0 sm:w-auto sm:text-sm">
                ยกเลิก
              </button>
            </div>
          </div>
        </transition>
      </div>
    </div>

  </div>
</template>

<script>
export default {
  data() {
    return {
      successMessages: '',
      errorMessages: [],
      mode: '',
      id: '',
      refNum: '',
      titles: [],
      nationalities: [],
      employers: [],

      title: '',
      firstName: '',
      lastName: '',
      dateOfBirth: '',
      nationality: '',
      employerName: '',

      title2: '',
      firstName2: '',
      lastName2: '',
      dateOfBirth2: '',
      nationality2: '',
      employerName2: '',

      locationId: '',
      locationName: '',
      appointmentDate: '',
      queue: '',
      services: [],
      serviceId: '',
      errorServiceModal: '',
      confirmCancelModal: false,
      showCreateEmployerBtn: false
    }
  },

  async fetch() {
    await this.$strapi.find('titles').then(result => {
      this.titles = result
    }).catch(err => {
      console.log(err)
    })

    await this.$strapi.find('nationalities').then(result => {
      this.nationalities = result
    }).catch(err => {
      console.log(err)
    })

    await this.$strapi.find('locations', {active: true}).then(result => {
      if (result.length === 1) {
        this.locationId = result[0]['id']
        this.locationName = result[0]['location_name']
        this.appointmentDate = result[0]['appointment_date']
      } else {
        this.errorMessages.push("กรุณาตรวจสอบการตั้งค่าระบบ")
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

    createServiceMode() {
      return this.mode === 'create service'
    },

    blankMode() {
      return this.mode !== ''
    },

    haveErrors() {
      return this.errorMessages.length > 0
    },

    titleName() {
      return this.title !== '' ? this.titles.find(x => x.id === this.title).title : ''
    },

    fullName() {
      return `${this.titleName} ${this.firstName} ${this.lastName}`
    },

    mobileCovidStation() {
      return `${this.locationName} (${this.$dayjs(this.appointmentDate, 'YYYY-MM-DD').format('DD/MM/BB')})`
    },
  },

  methods: {
    getPerson: async function () {
      let num = this.refNum
      if (num.length === 13 && /[0-9]{13}/.test(num)) {
        await this.$strapi.find('persons', {reference_number: num}).then(async result => {
          this.services = []
          if (result.length === 1) {
            this.mode = 'view'
            this.successMessages = ''
            this.errorMessages = []
            this.id = result[0]['id']
            this.title = result[0]['title']['id']
            this.firstName = result[0]['first_name']
            this.lastName = result[0]['last_name']
            this.dateOfBirth = result[0]['date_of_birth']
            this.nationality = result[0]['nationality']['id']
            this.employerName = result[0]['employer_name']
            this.services = await this.$strapi.find('services', {person: result[0]['id'], location: this.locationId})
          } else if (result.length === 0) {
            this.mode = 'create'
            this.successMessages = ''
            this.errorMessages = []
            this.id = ''
            this.title = ''
            this.firstName = ''
            this.lastName = ''
            this.dateOfBirth = ''
            this.nationality = ''
            this.employerName = ''
          }
        }).catch(err => {
          console.log(err)
        })
      } else if(/^q[0-9]{1,4}$/.test(num)) {
        let q = num.substring(1)
        await this.$strapi.find('services', {queue: q}).then(async result => {
          this.services = []
          if (result.length === 1) {
            this.mode = 'view'
            this.successMessages = ''
            this.errorMessages = []
            this.id = result[0]['person']['id']
            this.title = result[0]['person']['title']
            this.firstName = result[0]['person']['first_name']
            this.lastName = result[0]['person']['last_name']
            this.dateOfBirth = result[0]['person']['date_of_birth']
            this.refNum = result[0]['person']['reference_number']
            this.nationality = result[0]['person']['nationality']
            this.employerName = result[0]['person']['employer_name']
            this.services = await this.$strapi.find('services', {person: result[0]['person']['id'], location: this.locationId})
          }
        }).catch(err => {
          console.log(err)
        })
      }
    },

    createPerson: async function () {
      let num = this.refNum
      if (num.length === 13 && /[0-9]{13}/.test(num) && this.personValidation()) {
        await this.$strapi.find('persons', {reference_number: num}).then(async result => {
          if (result.length === 0) {
            await this.$strapi.create('persons', {
              reference_number: num,
              title: this.title,
              first_name: String(this.firstName).trim(),
              last_name: String(this.lastName).trim(),
              date_of_birth: this.dateOfBirth,
              nationality: this.nationality,
              employer_name: String(this.employerName).trim()
            }).then(async result => {
              this.mode = 'view'
              this.successMessages = 'ดำเนินการสร้างรายการสำเร็จ'
              this.errorMessages = []
              this.id = result['id']
              this.refNum = result['reference_number']
              this.title = result['title']['id']
              this.firstName = result['first_name']
              this.lastName = result['last_name']
              this.dateOfBirth = result['date_of_birth']
              this.nationality = result['nationality']['id']
              this.employerName = result['employer_name']
              await this.$strapi.create('employers', {name: result['employer_name']})
              this.employers = []
            }).catch(err => {
              console.log(err)
            })
          } else if (result.length === 1) {
            this.mode = 'view'
            this.successMessages = ''
            this.errorMessages = []
            this.id = result[0]['id']
            this.title = result[0]['title']['id']
            this.firstName = result[0]['first_name']
            this.lastName = result[0]['last_name']
            this.dateOfBirth = result['date_of_birth']
            this.nationality = result[0]['nationality']
            this.employerName = result['employer_name']
            this.employers = []
            this.services = await this.$strapi.find('services', {person: result[0]['id'], location: this.locationId})
          }
        }).catch(err => {
          console.log(err)
        })
      }
    },

    personValidation: function () {
      let a = true
      this.closeMessage()
      if (this.title === '') {
        this.errorMessages.push('โปรดระบุคำนำหน้าชื่อ')
        a = false
      }

      if (this.firstName === '' || this.lastName === '') {
        this.errorMessages.push('โปรดกรอก ชื่อ-นามสกุล ให้ถูกต้อง')
        a = false
      }

      if (this.dateOfBirth === '') {
        console.log(this.dateOfBirth)
        this.errorMessages.push('โปรดระบุวันเดือนปีเกิด')
        a = false
      }

      if (this.nationality === '') {
        this.errorMessages.push('โปรดระบุสัญชาติ')
        a = false
      }

      return a
    },

    editPerson: async function () {
      this.mode = 'edit'
      this.closeMessage()
      this.title2 = this.title
      this.firstName2 = this.firstName
      this.lastName2 = this.lastName
      this.dateOfBirth2 = this.dateOfBirth
      this.nationality2 = this.nationality
      this.employerName2 = this.employerName
    },

    updatePerson: async function () {
      let num = this.refNum
      console.log(this.dateOfBirth)
      if (num.length === 13 && /[0-9]{13}/.test(num) && this.personValidation()) {
        await this.$strapi.find('persons', {reference_number: num}).then(async result => {
          if (result.length === 1) {
            await this.$strapi.update('persons', this.id, {
              reference_number: num,
              title: this.title,
              first_name: String(this.firstName).trim(),
              last_name: String(this.lastName).trim(),
              date_of_birth: this.dateOfBirth,
              nationality: this.nationality,
              employer_name: String(this.employerName).trim(),
            }).then(async result => {
              this.mode = 'view'
              this.successMessages = 'ดำเนินการแก้ไขรายการสำเร็จ'
              this.errorMessages = []
              this.employers = []
              this.id = result['id']
              this.refNum = result['reference_number']
              this.title = result['title']['id']
              this.firstName = result['first_name']
              this.lastName = result['last_name']
              this.nationality = result['nationality']['id']
              this.employerName = result['employer_name']
              await this.$strapi.create('employers', {name: result['employer_name']})
              this.services = await this.$strapi.find('services', {person: this.id, location: this.locationId})
            }).catch(err => {
              console.log(err)
            })
          } else if (result.length === 0) {
            this.resetData()
          }
        }).catch(err => {
          console.log(err)
        })
      }
    },

    addService: async function () {
      this.mode = 'create service'
      this.closeMessage()
      this.$nextTick(function () {
        this.$refs.queue.focus()
      })
    },

    createService: async function () {
      this.closeMessage()
      let countService = await this.$strapi.count('services', {
        person: this.id,
        location: this.locationId
      })
      if (countService === 0) {
        await this.$strapi.find('services', {queue: this.queue, location: this.locationId}).then(async result => {
          if (result.length === 0) {
            await this.$strapi.create('services', {
              person: this.id,
              queue: this.queue,
              location: this.locationId,
              check_in: this.$dayjs().format('YYYY-MM-DD HH:mm')
            }).then(async result => {
              await this.$strapi.find('services', {
                person: this.id,
                location: this.locationId
              }).then(result => {
                this.services = result
                this.closeServiceModal()
                this.successMessages = 'ดำเนินการสร้างรายการเข้ารับบริการสำเร็จ'
              }).catch(err => {
                console.log(err)
              })
            }).catch(err => {
              console.log(err)
            })
          } else if (result.length === 1) {
            this.errorServiceModal = `มีการจองคิวนี้แล้ว โดยผู้มาตรวจหมายเลข ${result[0]['person']['reference_number']}`
          }
        }).catch(err => {
          console.log(err)
        })
      }
    },

    deleteService: async function () {
      this.closeMessage()
      await this.$strapi.delete('services', this.serviceId).then(async result => {
        this.serviceId = ''
        this.services = await this.$strapi.find('services', {person: this.id, location: this.locationId})
      })
    },

    closeServiceModal: function () {
      this.mode = 'view'
      this.queue = ''
    },

    focusInput: function () {
      this.$refs.search.removeAttribute('disabled')
      this.$refs.search.focus()
    },

    resetData() {
      this.mode = ''
      this.id = ''
      this.refNum = ''
      this.title = ''
      this.firstName = ''
      this.lastName = ''
      this.dateOfBirth = ''
      this.nationality = ''
      this.employerName = ''
      this.services = []
      this.employers = []
      this.errorServiceModal = ''
      this.serviceId = ''
      this.confirmCancelModal = false
      this.closeMessage()
      this.focusInput()
    },

    closeMessage: function () {
      this.successMessages = ''
      this.errorMessages = []
    },

    hasChanged: function () {
      return this.title2 !== this.title ||
        this.firstName2 !== this.firstName ||
        this.lastName2 !== this.lastName ||
        this.nationality2 !== this.nationality ||
        this.employerName2 !== this.employerName ||
        this.dateOfBirth2 !== this.dateOfBirth;
    },

    confirmCancel: function () {
      if (this.editMode) {
        this.mode = 'view'
        this.confirmCancelModal = false
        this.title = this.title2
        this.firstName = this.firstName2
        this.lastName = this.lastName2
        this.nationality = this.nationality2
        this.employerName = this.employerName2
        this.dateOfBirth = this.dateOfBirth2
        this.employers = []
      } else {
        this.resetData()
        this.confirmCancelModal = false
      }
    },

    cancel: function () {
      if (this.editMode && !this.hasChanged()) {
        this.mode = 'view'
      } else if (this.editMode && this.hasChanged()) {
        this.confirmCancelModal = true
      } else if (this.createMode && !this.hasChanged()) {
        this.resetData()
      } else if (this.createMode && this.hasChanged()) {
        this.confirmCancelModal = true
      } else {
        this.resetData()
      }
    },

    findEmployer: async function () {
      if (this.employerName.length >= 3 && (this.editMode || this.createMode)) {
        await this.$strapi.find('employers', {name_contains: this.employerName}).then(result => {
          this.employers = result
        })
      }

      if(this.employerName.length < 3) {
        this.employers = []
      } else if(this.employers.find(({name})=> name === this.employerName)) {
        this.employers = []
      }
    },
  },

  watch: {
    dateOfBirth: function ()  {
      if (this.dateOfBirth !== '') {
        let errMsg = 'วันเกิดมากกว่าวันปัจจุบัน กรุณาตรวจสอบใหม่อีกครั้ง'
        let strDob = String(this.dateOfBirth)
        let arrDob = strDob.split("-")

        if (strDob.charAt(4) !== '-') {
          arrDob[0] = `000${strDob.charAt(4)}`
          strDob = `${arrDob[0]}-${arrDob[1]}-${arrDob[2]}`
          this.dateOfBirth = strDob
          this.$refs.dob.focus()
        } else if (strDob.charAt(0) !== '0') {
          if (this.$dayjs(strDob).format('YYYYMMDD') > this.$dayjs().format('YYYYMMDD')) {
            if (this.errorMessages.indexOf(errMsg) === -1) {
              this.errorMessages.push(errMsg)
            }
            this.$refs.dob.focus()
          } else {
            this.errorMessages.splice(this.errorMessages.indexOf(errMsg), 1)
            this.$refs.dob.focus()
          }
        }
      }
    },
    employerName: function ()  {
      this.employerName = String(this.employerName).replace(/\s\s+/g, ' ');
    }
  }
}
</script>
