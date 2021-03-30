<template>
  <div class="px-4 py-5 sm:p-6">
    <div class="flex flex-col">
      <div class="-my-2 overflow-x-auto sm:-mx-6 lg:-mx-8">
        <div class="py-2 align-middle inline-block min-w-full sm:px-6 lg:px-8">
          <div
            class="shadow overflow-hidden border-b border-gray-200 sm:rounded-lg"
          >
            <table class="min-w-full divide-y divide-gray-200">
              <thead class="bg-gray-50">
                <tr>
                  <th
                    scope="col"
                    class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                  >
                    QUEUE
                  </th>
                  <th
                    scope="col"
                    class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                  >
                    ID/PASSPORT
                  </th>
                  <th
                    scope="col"
                    class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                  >
                    NAME
                  </th>
                  <th
                    scope="col"
                    class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                  >
                    DATE OF BIRTH
                  </th>
                  <th
                    scope="col"
                    class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                  >
                    EMPLOYER NAME
                  </th>
                </tr>
              </thead>
              <tbody class="bg-white divide-y divide-gray-200">
                <tr v-for="list in services" :key="list.id">
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                    {{ list.queue }}
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                    {{ list.person.reference_number }}
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                    {{ getTitle(list.person.title).title }} {{ list.person.first_name }} {{ list.person.last_name }}
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                    {{ list.person.date_of_birth }}
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                    {{ list.person.employer_name }}
                  </td>
                </tr>

                <!-- More items... -->
              </tbody>
            </table>
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
      locationId: "",
      locationName: "",
      appointmentDate: "",
      services: [],
      nationalities: [],
      titles: []
    };
  },
  async fetch() {
    await this.$strapi
      .find("locations", { active: true })
      .then(async result => {
        if (result.length === 1) {
          this.locationId = result[0]["id"];
          this.locationName = result[0]["location_name"];
          this.appointmentDate = result[0]["appointment_date"];
          await this.$strapi
            .find("services", { _limit: -1 })
            .then(res => {
              this.services = res;
            })
            .catch(err => {
              console.log(err);
            });

          await this.$strapi
            .find("titles")
            .then(res => {
              this.titles = res;
              console.log(this.titles);
            })
            .catch(err => {
              console.log(err);
            });

          await this.$strapi
            .find("nationalities")
            .then(res => {
              this.nationalities = res;
              console.log(this.nationalities);
            })
            .catch(err => {
              console.log(err);
            });
        } else {
          this.errorMessages.push("กรุณาตรวจสอบการตั้งค่าระบบ");
        }
      })
      .catch(err => {
        console.log(err);
      });
  },
  methods: {
    getTitle(id) {
      return this.titles.find(obj => obj.id === id);
    }
  }
};
</script>
