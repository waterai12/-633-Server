# install docker & nivida-docker
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get install docker-ce
## test docker
sudo docker run hello-world
## install nvidia-docker
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | \
  sudo apt-key add -
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | \
  sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-get update
# Install nvidia-docker2 and reload the Docker daemon configuration
sudo apt-get install -y nvidia-docker2
sudo pkill -SIGHUP dockerd

while getopts :zt opt
do
    case "$opt" in
        z)
		echo "Config Zsh & Oh-my-zsh"
		# zsh & oh-my-zsh
		apt-get install zsh curl
		sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
		
		# zsh-autosugesstions
		git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
		
		# autojump
		git clone https://github.com/wting/autojump.git ~/autojump
		cd ~/autojump
		./install.py
		echo "[[ -s ~/.autojump/etc/profile.d/autojump.sh ]] && . ~/.autojump/etc/profile.d/autojump.sh" >> ~/.zshrc
		cd ..
		rm -rf autojump
		
		# zsh-syntaxhighlight
		git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
		
		sed -i "66c git zsh-autosuggestions autojump zsh-syntax-highlighting" ~/.zshrc 
		chsh -s $(which zsh)
		;;
	t)
		apt-get install tmux
		echo "Config Tmux"
		# Tmux
		git clone https://github.com/gpakosz/.tmux.git ~/.tmux
		ln -s -f ~/.tmux/.tmux.conf
		cp ~/.tmux/.tmux.conf.local ~/
		sed -i '67c bind | split-window -h' ~/.tmux.conf
		;;
    esac
done
