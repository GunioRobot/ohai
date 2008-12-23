#
# Author:: Adam Jacob (<adam@opscode.com>)
# Copyright:: Copyright (c) 2008 OpsCode, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

if File.exists?("/sys/block")
  block = Mash.new
  Dir["/sys/block/*"].each do |block_device_dir|
    dir = File.basename(block_device_dir)
    block[dir] = Mash.new
    %w{size removable}.each do |check|
      if File.exists?("/sys/block/#{dir}/#{check}")
        block[dir][check] = from("cat /sys/block/#{dir}/#{check}")
      end
    end
    %w{model rev state timeout vendor}.each do |check|
      if File.exists?("/sys/block/#{dir}/device/#{check}")
        block[dir][check] = from("cat /sys/block/#{dir}/device/#{check}")
      end
    end
  end
  block_device block
end