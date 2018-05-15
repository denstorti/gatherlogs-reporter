class ServiceStatus < Inspec.resource(1)
  name 'service_status'
  desc 'Parse the service status for given product'

  def initialize(product)
    @product = product
    @content = parse_services(read_content(status_file))
  end

  def method_missing(service)
    @content[service.to_sym] if @content.has_key?(service.to_sym)
  end

  def exists?
    inspec.file(status_file).exists?
  end

  def each(&block)
    @content.each do |service,service_object|
      yield service_object
    end
  end

  private

  def status_file
    case @product.to_sym
    when :automate
      'delivery-ctl-status.txt'
    when :chef_server
      'private-chef-ctl_status.txt'
    end
  end

  def parse_services(content)
    services = {}
    internal = true
    content.each_line do |line|
      next if line =~ /[-]+/ # ------
      next if line =~ /^\s+$/ # blank lines
      next if line =~ /Internal Services/
      if line =~ /External Services/
        internal = false
        next
      end

      service_line, log_line = line.gsub(/[:\(\)]/, '').split(';')
      status, service, dummy, pid, runtime = service_line.split(/\s+/)

      services[service] = ServiceObject.new(name: service, status: status, pid: pid, runtime: runtime.to_i, internal: internal)
    end

    services
  end

  def read_content(filename)
    f = inspec.file(filename)
    if f.file?
      f.content
    else
      ''
    end
  end
end

class ServiceObject
  def initialize(args)
    @args = args
  end

  def exist?
    true
  end

  def method_missing(field)
    @args[field.to_sym] if @args.has_key?(field.to_sym)
  end

  def to_s
    @args[:name] || 'Unknown'
  end
end
