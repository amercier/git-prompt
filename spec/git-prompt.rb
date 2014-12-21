require 'tmpdir'
require 'open3'

SCRIPT = "\"#{Dir.pwd}/src/git-prompt.sh\""

describe 'git-prompt' do

  context 'in an empty directory' do
    dir = Dir.mktmpdir
    Dir.chdir Dir.new(dir) do
      stdin, stdout, stderr, wait_thr = Open3.popen3(SCRIPT)
      stdin.close
      it { expect(stderr.read).to eq('') }
      it { expect(stdout.read).to eq('') }
      it { expect(wait_thr.value).to eq(0) }
    end
  end

  context 'in an empty directory containing a .git subdirectory' do
    dir = Dir.mktmpdir
    Dir.chdir Dir.new(dir) do
      Dir.mkdir '.git'
      stdin, stdout, stderr, wait_thr = Open3.popen3(SCRIPT)
      stdin.close
      it { expect(stderr.read).to eq('') }
      it { expect(stdout.read).to eq('') }
      it { expect(wait_thr.value).to eq(0) }
    end
  end

end
